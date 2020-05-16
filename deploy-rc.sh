
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "rc" ]; then

  echo "Deploying rc branch..."

  . ./detect-deployment-details.sh

  echo "Install host: $INSTALL_HOST"

  if sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST '[ -d /usr/local/GrowSense/Index/ ]'; then
    echo "Waiting for deployment to unlock..."

    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash wait-for-unlock.sh" || echo "Failed to wait for unlock. Script likely doesn't exist because it hasn't been installed."

    echo ""

    echo "Renaming ventilator2 to NewVentilator so automatic device naming can be tested during deployment..."
    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash rename-device.sh ventilator2 NewVentilator" || echo "Failed to rename ventilator2 to NewVentilator."

    echo ""
    echo ""

    echo "Uninstalling GrowSense plug and play on remote computer..."
    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/uninstall-plug-and-play-from-web.sh | bash -s -- $BRANCH" || exit 1
  else
    echo "GrowSense Index directory not found on remote computer. Skipping uninstall."
  fi

  echo ""
  echo "Setting master as remote index..."
  echo "'rc' host: $RC_INSTALL_HOST"
  echo "'master' host: $MASTER_INSTALL_HOST"

  sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST  "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/add-remote-index-from-web.sh | bash -s -- $BRANCH ? GardenMaster $MASTER_INSTALL_HOST $MASTER_INSTALL_SSH_USERNAME $MASTER_INSTALL_SSH_PASSWORD $MASTER_INSTALL_SSH_PORT" || exit 1

  echo ""
  echo "Checking that remote index/computer was added..."
  if sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST '[ ! -d /usr/local/GrowSense/Index/remote/GardenMaster ]'; then
    echo "Remote computer/index at remote/GardenMaster wasn't found."
    exit 1
  fi
  echo ""


  echo ""
  echo "Installing GrowSense plug and play on remote computer..."

  sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/install-plug-and-play-from-web.sh | bash -s -- $BRANCH ? $WIFI_NAME $WIFI_PASSWORD $INSTALL_MQTT_HOST $INSTALL_MQTT_USERNAME $INSTALL_MQTT_PASSWORD $INSTALL_MQTT_PORT $SMTP_SERVER $EMAIL_ADDRESS $SMTP_USERNAME $SMTP_PASSWORD $SMTP_PORT" || exit 1

  echo ""

  echo "Checking deployment..."
  bash check-deployment.sh || exit 1

  echo ""

  echo "Finished deployment."
else
  echo "You're not in the rc branch. Skipping rc deployment."
fi
