
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "lts" ]; then

  echo "Deploying lts branch..."
  echo "Host: $LTS_INSTALL_HOST"

  echo "Uninstalling GreenSense plug and play on remote computer..."
  echo "Host: $LTS_INSTALL_HOST"

  sshpass -p $LTS_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $LTS_INSTALL_SSH_USERNAME@$LTS_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH/scripts-web/uninstall-plug-and-play-from-web.sh | bash -s -- $BRANCH"


  echo "Setting master branch garden as remote index..."
  echo "'lts' host: $LTS_INSTALL_HOST"
  echo "'master' host: $MASTER_INSTALL_HOST"

  sshpass -p $LTS_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $LTS_INSTALL_SSH_USERNAME@$LTS_INSTALL_HOST "wget -v --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH/scripts-web/add-remote-index-from-web.sh | bash -s -- $BRANCH ? master $MASTER_INSTALL_HOST $MASTER_INSTALL_SSH_USERNAME $MASTER_INSTALL_SSH_PASSWORD"


  echo "Installing GreenSense plug and play on remote computer..."
  echo "Host: $LTS_INSTALL_HOST"

  sshpass -p $LTS_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $LTS_INSTALL_SSH_USERNAME@$LTS_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH/scripts-web/install-plug-and-play-from-web.sh | bash -s -- $BRANCH ? $WIFI_NAME $WIFI_PASSWORD $LTS_MQTT_HOST $LTS_MQTT_USERNAME $LTS_MQTT_PASSWORD $LTS_MQTT_PORT $SMTP_SERVER $EMAIL_ADDRESS"

  echo "Giving services time to start..."
  sleep 30
  
  echo "Checking deployment..."
  bash check-deployment.sh || exit 1

  echo "Finished deployment."
else
  echo "You're not in the lts branch. Skipping lts deployment."
fi
