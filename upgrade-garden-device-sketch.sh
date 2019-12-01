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
echo "  Device board: $DEVICE_BOARD"
echo "  Device project: $DEVICE_PROJECT"
echo "  Device group: $DEVICE_GROUP"
echo "  Device port: $DEVICE_PORT"
echo "  Device host: $DEVICE_HOST"
echo "  Current host: $CURRENT_HOST"

echo "  Waiting for devices to unlock (to ensure no device sketches are being uploaded)..."
bash wait-for-unlock.sh || exit 1

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
  mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/Q/in" -m "1" -q 2

  # Give the device time to respond
  sleep 10

  # Get the version from the device
  VERSION=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/V" -C 1 -q 2)

  if [ ! "$VERSION" ]; then
    echo "  Device version: No MQTT data detected"
    echo "  Latest version ($BRANCH): $LATEST_FULL_VERSION"
  else
    echo "  Device version: $VERSION"
    echo "  Latest version ($BRANCH): $LATEST_FULL_VERSION"
    
    if [ ! "$LATEST_BUILD_NUMBER" ]; then
      echo "  Error: Failed to retrieve the latest build number from the repository."
    elif [ ! "$LATEST_VERSION_NUMBER" ]; then
      echo "  Error: Failed to retrieve the latest version number from the repository."
    elif [ "$VERSION" = "$LATEST_FULL_VERSION" ]; then
      echo "  Already on the latest version. Skipping upload."
    else
      echo "  Needs to be updated."
      
      mkdir -p "logs/updates"
      
      echo "  Checking out latest device project repository..."
      cd "sketches/$DEVICE_GROUP/$DEVICE_PROJECT"
      sh clean.sh
      git checkout $BRANCH
      git pull origin $BRANCH
      cd $DIR
      
      # Publish the status. The device is being upgraded.
      bash mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Upgrading" || echo "Failed to publish device status 'Upgrading'."
      
      bash create-message-file.sh "$DEVICE_NAME is upgrading"
      
      if [ "$DEVICE_GROUP" = "ui" ]; then  
        echo "Giving the UI time to display the message..."
        sleep 5 
      fi

      # Stop the service so the upgrade can execute
      sh stop-garden-device.sh $DEVICE_NAME

      # Give the services time to stop
      sleep 2
      
      LOG_FILE="logs/updates/$DEVICE_NAME.txt"
       
      echo ""
      echo "  Launching device upload script..."
      if [[ "$DEVICE_BOARD" == "esp" ]]; then
        echo "    Is ESP board. Launching upload ESP script...."
        SCRIPT_NAME="upload-device-sketch-esp.sh"
        echo "    Script: $SCRIPT_NAME"
        timeout $UPGRADE_SCRIPT_TIMEOUT bash $SCRIPT_NAME $DEVICE_GROUP $DEVICE_PROJECT $DEVICE_NAME $DEVICE_PORT > $LOG_FILE
      else
        echo "    Is arduino board. Launching upload arduino script...."
        SCRIPT_NAME="upload-device-sketch-arduino.sh"
        echo "    Script: $SCRIPT_NAME"
        timeout $UPGRADE_SCRIPT_TIMEOUT bash $SCRIPT_NAME $DEVICE_BOARD $DEVICE_GROUP $DEVICE_PROJECT $DEVICE_NAME $DEVICE_PORT > $LOG_FILE
      fi

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

        echo "${LOG_OUTPUT}"
        
        bash send-email.sh "Error: Upgrade timed out for $DEVICE_NAME (on $DEVICE_HOST)" "Upgrade timed out $DEVICE_NAME (on $DEVICE_HOST)\n\nPrevious version: $VERSION\nNew version: $LATEST_FULL_VERSION\n\nBranch: $BRANCH\n\nCurrent host: $CURRENT_HOST\nDevice host: $DEVICE_HOST\n\nStatus code: $?\n\n$LOG_OUTPUT"
        
        bash create-alert-file.sh "Upgrade timed out for $DEVICE_NAME (on $DEVICE_HOST)"

        exit 1
      fi
      
      # If the upgrade script completed successfully
      if [ $STATUS_CODE = 0 ]; then
        sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Upgrade Complete"

        echo "Upgrade complete\n---------- End Upgrade Log ----------\n\n\n\n" >> $LOG_FILE
       
        echo "Device has been upgraded"   
        
        LOG_OUTPUT=$(cat $LOG_FILE)
        
        bash send-email.sh "Upgrade successful (v$LATEST_FULL_VERSION) for $DEVICE_NAME (on $DEVICE_HOST)" "Upgraded sketch for $DEVICE_NAME (on $DEVICE_HOST)\n\nPrevious version: $VERSION\nNew version: $LATEST_FULL_VERSION\n\nBranch: $BRANCH\n\nCurrent host: $CURRENT_HOST\nDevice host: $DEVICE_HOST\n\nStatus code: $?\n\n$LOG_OUTPUT"

        bash create-message-file.sh "Upgrade successful (v$LATEST_FULL_VERSION) for $DEVICE_NAME (on $DEVICE_HOST)"

      else # Upgrade failed
        sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Upgrade Failed"
        
        echo "Upgrade failed\n---------- End Upgrade Log ----------\n\n\n\n" >> $LOG_FILE
       
        echo "Device upgrade failed" 

        LOG_OUTPUT=$(cat $LOG_FILE)

        echo "${LOG_OUTPUT}"
        
        bash send-email.sh "Error: Upgrade failed for $DEVICE_NAME (on $DEVICE_HOST)" "Failed to upgrade sketch for $DEVICE_NAME (on $DEVICE_HOST)\n\nPrevious version: $VERSION\nNew version: $LATEST_FULL_VERSION\n\nBranch: $BRANCH\n\nCurrent host: $CURRENT_HOST\nDevice host: $DEVICE_HOST\n\nStatus code: $?\n\n$LOG_OUTPUT"

        bash create-alert-file.sh "Upgrade failed for $DEVICE_NAME (on $DEVICE_HOST)"
      fi
    fi
  fi
else
  echo "  Device is not connected via USB. Skipping upgrade."
fi

