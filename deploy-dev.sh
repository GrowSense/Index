
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ]; then

  echo "Deploying dev branch..."

  echo ""

  . ./detect-deployment-details.sh


  echo "Install host: $INSTALL_HOST"

  if sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST '[ -d /usr/local/GrowSense/Index/ ]'; then
    echo "Waiting for deployment to unlock..."
    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash wait-for-unlock.sh" || echo "Failed to wait for unlock. Script likely doesn't exist because it hasn't been installed."

    echo ""

    echo "Removing git config user and email to ensure deployment will still work without them..."
    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && git config --global --unset user.name && git config --global --unset user.email" || echo "Failed to remove git config user and email"

    echo ""

    echo "Renaming illuminator1 to NewIlluminator so automatic device naming can be tested during deployment..."
    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash rename-device.sh illuminator1 NewIlluminator" || echo "Failed to rename illuminator1 to NewIlluminator."

    echo ""

    echo "Renaming irrigatorW1 to NewIrrigatorW so automatic device naming can be tested during deployment..."
    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash rename-device.sh irrigatorW1 NewIrrigatorW" || echo "Failed to rename irrigatorW1 to NewIrrigatorW."

    echo ""

    echo "Uninstalling GrowSense plug and play on remote computer..."
    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/uninstall-plug-and-play-from-web.sh | bash -s -- $BRANCH" || exit 1
  else
    echo "GrowSense Index directory not found on remote computer. Skipping uninstall."
  fi

  echo ""

  echo ""
  echo "Setting devstaging2 as remote index..."
  echo "'devstaging' host: $DEV_INSTALL_HOST"
  echo "'devstaging2' host: $DEVSTAGING2_INSTALL_HOST"

  sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST  "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/add-remote-index-from-web.sh | bash -s -- $BRANCH ? dev2 $DEVSTAGING2_INSTALL_HOST $DEVSTAGING2_INSTALL_SSH_USERNAME $DEVSTAGING2_INSTALL_SSH_PASSWORD $DEVSTAGING2_INSTALL_SSH_PORT" || exit 1

  echo ""
  echo "Checking that remote index/computer was added..."
  if sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST '[ ! -d /usr/local/GrowSense/Index/remote/dev2 ]'; then
    echo "Remote computer/index at remote/dev2 wasn't found."
    exit 1
  fi

  echo ""

  echo ""
  echo "Installing GrowSense plug and play on remote computer..."

  sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Installer/$BRANCH/scripts-download/download-installer.sh | bash -s -- --branch=$BRANCH --to=/usr/local/ || exit 1
# ? $WIFI_NAME $WIFI_PASSWORD $INSTALL_MQTT_HOST $INSTALL_MQTT_USERNAME $INSTALL_MQTT_PASSWORD $INSTALL_MQTT_PORT $SMTP_SERVER $EMAIL_ADDRESS $SMTP_USERNAME $SMTP_PASSWORD $SMTP_PORT" || exit 
  #sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Installer/$BRANCH/scripts-download/download-installer.sh | bash -s -- --branch=$BRANCH ? $WIFI_NAME $WIFI_PASSWORD $INSTALL_MQTT_HOST $INSTALL_MQTT_USERNAME $INSTALL_MQTT_PASSWORD $INSTALL_MQTT_PORT $SMTP_SERVER $EMAIL_ADDRESS $SMTP_USERNAME $SMTP_PASSWORD $SMTP_PORT" || exit 1
exit 1
  echo ""
  echo "Setting supervisor settings..."

  sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index/ && echo 10 > supervisor-status-check-frequency.txt && echo 10 > supervisor-docker-check-frequency.txt && echo 10 > supervisor-mqtt-check-frequency.txt" || exit 1

  echo ""
  echo "Checking deployment..."
  bash check-deployment.sh || exit 1

  echo ""

  echo "Finished deployment."
else
  echo "You're not in the dev branch. Skipping dev deployment."
fi
