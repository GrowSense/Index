
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "rc" ]; then

  echo "Deploying master branch update..."

  echo ""

  . ./detect-deployment-details.sh

  echo "Install host: $INSTALL_HOST"

  if sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "[ -d /usr/local/GrowSense/Index ]"; then
    echo ""
    echo "Waiting for deployment to unlock..."

    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash wait-for-unlock.sh" || echo "Failed to wait for unlock. Script likely doesn't exist because it hasn't been installed."

    echo ""
    echo "Setting email details in case they've changed..."

    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash set-email-details.sh $SMTP_SERVER $EMAIL_ADDRESS $SMTP_USERNAME $SMTP_PASSWORD $SMTP_PORT" || echo "Failed to set email details."

    echo ""
    echo "Setting MQTT settings in case they've changed..."

    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash set-mqtt-credentials.sh $INSTALL_MQTT_HOST $INSTALL_MQTT_USERNAME $INSTALL_MQTT_PASSWORD $INSTALL_MQTT_PORT" || echo "Failed to set email details."

    echo ""
    echo "Updating GrowSense plug and play on remote host..."

    FORCE_UPDATE=1
    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "wget --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/update-plug-and-play-from-web.sh | bash -s -- $BRANCH ? $FORCE_UPDATE"

    echo ""
    echo "Checking deployment..."
    bash check-deployment.sh || exit 1
  else
    echo "  GrowSense isn't installed. Skipping update."
  fi

  echo "Finished deployment."
else
  echo "You're not in the master branch. Skipping master deployment."
fi
