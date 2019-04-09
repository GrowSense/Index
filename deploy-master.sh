
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "master" ]; then

  echo "Deploying master branch..."
  echo "Host: $MASTER_INSTALL_HOST"

  echo "Uninstalling GreenSense plug and play on remote computer..."
  echo "Host: $MASTER_INSTALL_HOST"

  sshpass -p $MASTER_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $MASTER_INSTALL_SSH_USERNAME@$MASTER_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH_NAME/scripts-web/uninstall-plug-and-play-from-web.sh | bash -s -- $BRANCH_NAME" || exit 1

  echo "Installing GreenSense plug and play on remote computer..."
  echo "Host: $MASTER_INSTALL_HOST"

  sshpass -p $MASTER_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $MASTER_INSTALL_SSH_USERNAME@$MASTER_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH_NAME/scripts-web/install-plug-and-play-from-web.sh | bash -s -- $BRANCH_NAME ? $WIFI_NAME $WIFI_PASSWORD $MASTER_MQTT_HOST $MASTER_MQTT_USERNAME $MASTER_MQTT_PASSWORD $MASTER_MQTT_PORT $SMTP_SERVER $EMAIL_ADDRESS"  || exit 1

  echo "Giving services time to start..."
  sleep 30
  
  echo "Checking deployment..."
  bash check-deployment.sh

  echo "Finished deployment."
else
  echo "You're not in the master branch. Skipping master deployment."
fi
