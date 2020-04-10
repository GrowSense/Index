
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "master" ]; then

  echo "Deploying master branch..."

  echo ""

  . ./detect-deployment-details.sh

  echo "Install host: $INSTALL_HOST"

  if sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST '[ -d /usr/local/GrowSense/Index/ ]'; then
    echo "Waiting for deployment to unlock..."
    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash wait-for-unlock.sh" || echo "Failed to wait for unlock. Script likely doesn't exist because it hasn't been installed."

    echo ""

    echo "Renaming irrigatorW1 to NewIrrigatorW so automatic device naming can be tested during deployment..."
    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash rename-device.sh irrigatorW1 NewIrrigatorW" || echo "Failed to rename illuminator1 to NewIlluminator. Script likely doesn't exist because it hasn't been installed."

    echo ""

    echo "Uninstalling GrowSense plug and play on remote computer..."
    echo "Host: $MASTER_INSTALL_HOST"

    sshpass -p $MASTER_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $MASTER_INSTALL_SSH_USERNAME@$MASTER_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/uninstall-plug-and-play-from-web.sh | bash -s -- $BRANCH" || exit 1

    echo ""
  fi

  echo "Installing GrowSense plug and play on remote computer..."
  echo "Host: $MASTER_INSTALL_HOST"

  sshpass -p $MASTER_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $MASTER_INSTALL_SSH_USERNAME@$MASTER_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/install-plug-and-play-from-web.sh | bash -s -- $BRANCH ? $WIFI_NAME $WIFI_PASSWORD $MASTER_MQTT_HOST $MASTER_MQTT_USERNAME $MASTER_MQTT_PASSWORD $MASTER_MQTT_PORT $SMTP_SERVER $EMAIL_ADDRESS $SMTP_USERNAME $SMTP_PASSWORD $SMTP_PORT"  || exit 1

  echo ""

  echo "Checking deployment..."
  bash check-deployment.sh || exit 1

  echo ""

  echo "Finished deployment."
else
  echo "You're not in the master branch. Skipping master deployment."
fi
