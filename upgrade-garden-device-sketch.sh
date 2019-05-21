DIR=$PWD

DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

UPGRADE_SCRIPT_TIMEOUT="5m"

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

MQTT_HOST=$(cat mqtt-host.security)
MQTT_USERNAME=$(cat mqtt-username.security)
MQTT_PASSWORD=$(cat mqtt-password.security)
MQTT_PORT=$(cat mqtt-port.security)

DEVICE_PROJECT=$(cat "devices/$DEVICE_NAME/project.txt")
DEVICE_BOARD=$(cat "devices/$DEVICE_NAME/board.txt")
DEVICE_GROUP=$(cat "devices/$DEVICE_NAME/group.txt")
DEVICE_PORT=$(cat "devices/$DEVICE_NAME/port.txt")
DEVICE_HOST=$(cat "devices/$DEVICE_NAME/host.txt")

CURRENT_HOST=$(cat /etc/hostname)

echo "  Device name: $DEVICE_NAME"
echo "  Device project: $DEVICE_PROJECT"
echo "  Device host: $DEVICE_HOST"
echo "  Current host: $CURRENT_HOST"

if [ "$DEVICE_HOST" = "$CURRENT_HOST" ]; then

  # Get the latest version from the GitHub repository
  #LATEST_BUILD_NUMBER=$(curl -sL -H "Cache-Control: no-cache" https://raw.githubusercontent.com/GreenSense/$DEVICE_PROJECT/$BRANCH/buildnumber.txt)
  #LATEST_VERSION_NUMBER=$(curl -sL -H "Cache-Control: no-cache" https://raw.githubusercontent.com/GreenSense/$DEVICE_PROJECT/$BRANCH/version.txt)
  LATEST_BUILD_NUMBER=$(wget --no-cache "https://raw.githubusercontent.com/GreenSense/$DEVICE_PROJECT/$BRANCH/buildnumber.txt" -q -O -)
  LATEST_VERSION_NUMBER=$(wget --no-cache "https://raw.githubusercontent.com/GreenSense/$DEVICE_PROJECT/$BRANCH/version.txt" -q -O -)

  LATEST_FULL_VERSION="$LATEST_VERSION_NUMBER-$LATEST_BUILD_NUMBER"

  # Get the version from the device
  VERSION=$(timeout 10 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/V" -C 1)

  if [ ! "$VERSION" ]; then
    echo "  Device version: No MQTT data detected"
    echo "  Latest version ($BRANCH): $LATEST_FULL_VERSION"
  else
    echo "  Device version: $VERSION"
    echo "  Latest version ($BRANCH): $LATEST_FULL_VERSION"
    
    if [ "$VERSION" = "$LATEST_FULL_VERSION" ]; then
      echo "  Already on the latest version. Skipping upload."
    else
      echo "  Needs to be updated."
      
      mkdir -p "logs/updates"
      
      cd "sketches/$DEVICE_GROUP/$DEVICE_PROJECT"
      sh clean.sh
      git pull origin $BRANCH
      cd $DIR
      
      # Publish the status. The device is being upgraded.
      sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Upgrading" || (echo "Failed to publish device status 'Updgrading'." && exit 1)
      
      SERVICE_NAME="greensense-mqtt-bridge-$DEVICE_NAME.service"
      
      if [ "$DEVICE_GROUP" = "ui" ]; then  
        echo "Giving the UI time to display the message..."
        sleep 5 
      fi

      # Stop the service so the upgrade can execute
      sh stop-garden-device.sh $DEVICE_NAME
        
      SCRIPT_NAME="upload-$DEVICE_GROUP-$DEVICE_BOARD-sketch.sh"
      timeout $UPGRADE_SCRIPT_TIMEOUT sh $SCRIPT_NAME $DEVICE_PORT >> logs/updates/$DEVICE_NAME.txt || \
        (sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Upgrade failed" && echo "Upgrade failed" && exit 1)

      
      STATUS_CODE=$?    
      
      echo "Status code: $STATUS_CODE"
      
      # Start the device again
      sh start-garden-device.sh $DEVICE_NAME
    
      if [ "$DEVICE_GROUP" = "ui" ]; then  
        echo "Giving the UI time to restart..."
        sleep 10
      fi
      
      # If the upgrade script timed out
      if [ $STATUS_CODE = 124 ]; then
        sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Upgrade timed out"
        
        echo "Upgrade timed out"
        
        echo "Upgrade timed out" >> logs/updates/$DEVICE_NAME.txt
        
        exit 1
      fi
      
      
      # If the upgrade script completed successfully
      if [ $STATUS_CODE = 0 ]; then
        sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Upgrade Complete"

        echo "Upgrade complete" >> logs/updates/$DEVICE_NAME.txt
       
        echo "Device has been upgraded"   
      else # Upgrade failed
        sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Upgrade Failed"
        
        echo "Upgrade failed" >> logs/updates/$DEVICE_NAME.txt
       
        echo "Device upgrade failed" 
      fi

       
    fi
  fi
else
  echo "Device is on a remote host. Skipping upgrade."
fi

