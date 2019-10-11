DIR=$PWD

DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

UPGRADE_SCRIPT_TIMEOUT="15m"

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
DEVICE_IS_USB_CONNECTED=$(cat "devices/$DEVICE_NAME/is-usb-connected.txt")

CURRENT_HOST=$(cat /etc/hostname)

echo "  Device name: $DEVICE_NAME"
echo "  Device project: $DEVICE_PROJECT"
echo "  Device host: $DEVICE_HOST"
echo "  Current host: $CURRENT_HOST"

if [ "$DEVICE_HOST" != "$CURRENT_HOST" ]; then
  echo "  Device is on another host. Skipping upgrade."
  exit 0
elif [ "$DEVICE_IS_USB_CONNECTED" = "1" ]; then
  # Get the latest version from the GitHub repository
  LATEST_BUILD_NUMBER=$(curl -sL -H "Cache-Control: no-cache" https://raw.githubusercontent.com/GrowSense/$DEVICE_PROJECT/$BRANCH/buildnumber.txt)
  LATEST_VERSION_NUMBER=$(curl -sL -H "Cache-Control: no-cache" https://raw.githubusercontent.com/GrowSense/$DEVICE_PROJECT/$BRANCH/version.txt)
  #LATEST_BUILD_NUMBER=$(wget --no-cache "https://raw.githubusercontent.com/GrowSense/$DEVICE_PROJECT/$BRANCH/buildnumber.txt" -q -O -)
  #LATEST_VERSION_NUMBER=$(wget --no-cache "https://raw.githubusercontent.com/GrowSense/$DEVICE_PROJECT/$BRANCH/version.txt" -q -O -)

  LATEST_FULL_VERSION="$LATEST_VERSION_NUMBER-$LATEST_BUILD_NUMBER"

  # Query the device to force it to output a line of data
  mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/Q/in" -m "1" -q 2

  # Give the device time to respond
  sleep 20

  # Get the version from the device
  VERSION=$(timeout 10 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/V" -C 1 -q 2)

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
      git checkout $BRANCH
      git pull origin $BRANCH
      cd $DIR
      
      # Publish the status. The device is being upgraded.
      sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Upgrading" || echo "Failed to publish device status 'Upgrading'."
      
      SERVICE_NAME="greensense-mqtt-bridge-$DEVICE_NAME.service"
      
      if [ "$DEVICE_GROUP" = "ui" ]; then  
        echo "Giving the UI time to display the message..."
        sleep 5 
      fi

      # Stop the service so the upgrade can execute
      sh stop-garden-device.sh $DEVICE_NAME

      # Give the services time to stop
      sleep 2
      
      LOG_FILE="logs/updates/$DEVICE_NAME.txt"
        
      SCRIPT_NAME="upload-$DEVICE_GROUP-$DEVICE_BOARD-sketch.sh"
      timeout $UPGRADE_SCRIPT_TIMEOUT bash $SCRIPT_NAME $DEVICE_NAME $DEVICE_PORT >> $LOG_FILE

      STATUS_CODE=$?
      
      echo "Status code: $STATUS_CODE"
      
      echo "Giving the device time to restart..."
      sleep 5
      
      # Start the device again
      sh start-garden-device.sh $DEVICE_NAME
    
      if [ "$DEVICE_GROUP" = "ui" ]; then  
        echo "Giving the UI controller time to restart..."
        sleep 10
      fi
      
      # If the upgrade script timed out
      if [ $STATUS_CODE = 124 ]; then
        sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Upgrade timed out"
        
        echo "Upgrade timed out"
        
        echo "Upgrade timed out\n---------- End Upgrade Log ----------\n\n\n\n" >> $LOG_FILE
        
        LOG_OUTPUT=$(cat $LOG_FILE)
        
        bash send-email.sh "Error: Upgrade timed out for $DEVICE_NAME on $DEVICE_HOST" "Upgrade timed out $DEVICE_NAME on $DEVICE_HOST\n\nPrevious version: $VERSION\nNew version: $LATEST_FULL_VERSION\n\nBranch: $BRANCH\n\nCurrent host: $CURRENT_HOST\nDevice host: $DEVICE_HOST\n\nStatus code: $?\n\n$LOG_OUTPUT"
        
        exit 1
      fi
      
      # If the upgrade script completed successfully
      if [ $STATUS_CODE = 0 ]; then
        sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Upgrade Complete"

        echo "Upgrade complete\n---------- End Upgrade Log ----------\n\n\n\n" >> $LOG_FILE
       
        echo "Device has been upgraded"   
        
        LOG_OUTPUT=$(cat $LOG_FILE)
        
        bash send-email.sh "Upgrade successful for $DEVICE_NAME on $DEVICE_HOST" "Upgraded sketch for $DEVICE_NAME on $DEVICE_HOST\n\nPrevious version: $VERSION\nNew version: $LATEST_FULL_VERSION\n\nBranch: $BRANCH\n\nCurrent host: $CURRENT_HOST\nDevice host: $DEVICE_HOST\n\nStatus code: $?\n\n$LOG_OUTPUT"
      else # Upgrade failed
        sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Upgrade Failed"
        
        echo "Upgrade failed\n---------- End Upgrade Log ----------\n\n\n\n" >> $LOG_FILE
       
        echo "Device upgrade failed" 

        LOG_OUTPUT=$(cat $LOG_FILE)
        
        bash send-email.sh "Error: Upgrade failed for $DEVICE_NAME on $DEVICE_HOST" "Failed to upgrade sketch for $DEVICE_NAME on $DEVICE_HOST\n\nPrevious version: $VERSION\nNew version: $LATEST_FULL_VERSION\n\nBranch: $BRANCH\n\nCurrent host: $CURRENT_HOST\nDevice host: $DEVICE_HOST\n\nStatus code: $?\n\n$LOG_OUTPUT"
      fi
    fi
  fi
else
  echo "  Device is not connected via USB. Skipping upgrade."
fi

