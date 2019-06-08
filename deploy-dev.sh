
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ]; then

  echo "Deploying dev branch..."
  
  echo ""

  echo "Uninstalling GreenSense plug and play on remote computer..."

  sshpass -p $DEV_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $DEV_INSTALL_SSH_USERNAME@$DEV_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH/scripts-web/uninstall-plug-and-play-from-web.sh | bash -s -- $BRANCH" || exit 1

  echo ""
  
  echo "Installing GreenSense plug and play on remote computer..."

  sshpass -p $DEV_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $DEV_INSTALL_SSH_USERNAME@$DEV_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH/scripts-web/install-plug-and-play-from-web.sh | bash -s -- $BRANCH ? $WIFI_NAME $WIFI_PASSWORD $DEV_MQTT_HOST $DEV_MQTT_USERNAME $DEV_MQTT_PASSWORD $DEV_MQTT_PORT $SMTP_SERVER $EMAIL_ADDRESS" || exit 1
  
  echo ""
  
  echo "Giving services time to start..."
  sleep 120
  
  echo ""
  
  echo "Checking deployment..."
  bash check-deployment.sh || exit 1
  
  echo ""
  
  echo "Finished deployment."
else
  echo "You're not in the dev branch. Skipping dev deployment."
fi
