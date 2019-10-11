
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "lts" ]; then

  echo "Deploying lts branch..."
  echo "Host: $LTS_INSTALL_HOST"

  echo ""
  
  echo "Waiting for deployment to unlock..."
  . ./detect-deployment-details.sh
  sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash wait-for-unlock.sh" || echo "Failed to wait for unlock. Script likely doesn't exist because it hasn't been installed."
  
  echo ""
  
  echo "Uninstalling GrowSense plug and play on remote computer..."
  echo "Host: $LTS_INSTALL_HOST"

  sshpass -p $LTS_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $LTS_INSTALL_SSH_USERNAME@$LTS_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/uninstall-plug-and-play-from-web.sh | bash -s -- $BRANCH"

  echo ""

  echo "Setting master branch garden as remote index..."
  echo "'lts' host: $LTS_INSTALL_HOST"
  echo "'master' host: $MASTER_INSTALL_HOST"

  sshpass -p $LTS_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $LTS_INSTALL_SSH_USERNAME@$LTS_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/add-remote-index-from-web.sh | bash -s -- $BRANCH ? master $MASTER_INSTALL_HOST $MASTER_INSTALL_SSH_USERNAME $MASTER_INSTALL_SSH_PASSWORD"

  echo ""
  
  echo "Installing GrowSense plug and play on remote computer..."
  echo "Host: $LTS_INSTALL_HOST"

  sshpass -p $LTS_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $LTS_INSTALL_SSH_USERNAME@$LTS_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/install-plug-and-play-from-web.sh | bash -s -- $BRANCH ? $WIFI_NAME $WIFI_PASSWORD $LTS_MQTT_HOST $LTS_MQTT_USERNAME $LTS_MQTT_PASSWORD $LTS_MQTT_PORT $SMTP_SERVER $EMAIL_ADDRESS"

  echo ""

  echo "Checking deployment..."
  bash check-deployment.sh || exit 1

  echo ""
  
  echo "Finished deployment."
else
  echo "You're not in the lts branch. Skipping lts deployment."
fi
