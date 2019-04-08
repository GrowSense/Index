
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ]; then

  echo "Deploying dev branch..."

  echo "Updating GreenSense plug and play on remote computer..."
  
  echo "Host: $DEV_INSTALL_HOST"

  sshpass -p $DEV_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $DEV_INSTALL_SSH_USERNAME@$DEV_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH_NAME/scripts-web/update-plug-and-play-from-web.sh | bash -s -- $BRANCH_NAME" || exit 1


  echo "Uninstalling GreenSense plug and play on remote computer..."

  sshpass -p $DEV_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $DEV_INSTALL_SSH_USERNAME@$DEV_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH_NAME/scripts-web/uninstall-plug-and-play-from-web.sh | bash -s -- $BRANCH_NAME" || exit 1

  echo "Installing GreenSense plug and play on remote computer..."

  sshpass -p $DEV_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $DEV_INSTALL_SSH_USERNAME@$DEV_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH_NAME/scripts-web/install-plug-and-play-from-web.sh | bash -s -- $BRANCH_NAME ? $WIFI_NAME $WIFI_PASSWORD $DEV_MQTT_HOST $DEV_MQTT_USERNAME $DEV_MQTT_PASSWORD $DEV_MQTT_PORT $SMTP_SERVER $EMAIL_ADDRESS" || exit 1

  echo "Finished deployment."
else
  echo "You're not in the dev branch. Skipping dev deployment."
fi
