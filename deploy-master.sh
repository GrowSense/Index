
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "master" ]; then

# Update disabled. Full uninstall and reinstall works better
#  echo "Updating GreenSense plug and play on remote computer..."

#  sshpass -p $MASTER_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $MASTER_INSTALL_SSH_USERNAME@$MASTER_INSTALL_HOST "wget --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH_NAME/scripts-web/update-plug-and-play-from-web.sh | bash -s -- $BRANCH_NAME" || (echo "Update failed" && exit 1)


  echo "Uninstalling GreenSense plug and play on remote computer..."

  sshpass -p $MASTER_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $MASTER_INSTALL_SSH_USERNAME@$MASTER_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH_NAME/scripts-web/uninstall-plug-and-play-from-web.sh | bash -s -- $BRANCH_NAME" || (echo "Uninstall failed" && exit 1)

  echo "Installing GreenSense plug and play on remote computer..."

  sshpass -p $MASTER_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $MASTER_INSTALL_SSH_USERNAME@$MASTER_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH_NAME/scripts-web/install-plug-and-play-from-web.sh | bash -s -- $BRANCH_NAME ? $WIFI_NAME $WIFI_PASSWORD $MASTER_MQTT_HOST $MASTER_MQTT_USERNAME $MASTER_MQTT_PASSWORD $MASTER_MQTT_PORT $SMTP_SERVER $EMAIL_ADDRESS"  || (echo "Install failed" && exit 1)


  echo "Finished deployment."
else
  echo "You're not in the master branch. Skipping master deployment."
fi
