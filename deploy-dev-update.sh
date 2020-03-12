
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ]; then

  echo "Deploying dev branch update..."

  echo ""

  . ./detect-deployment-details.sh

  echo "Host: $INSTALL_HOST"

  if sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "[ -f /usr/local/GrowSense/Index/upgrade-system.sh ]"; then
    echo ""
    echo "Waiting for deployment to unlock..."

    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash wait-for-unlock.sh" || echo "Failed to wait for unlock. Script likely doesn't exist because it hasn't been installed."

    echo ""
    echo "Updating GrowSense plug and play on remote computer..."

    FORCE_UPDATE=1

    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/update-plug-and-play-from-web.sh | bash -s -- $BRANCH ? $FORCE_UPDATE" || exit 1

    echo ""
    echo "Setting supervisor settings..."

    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index/ && echo 10 > supervisor-status-check-frequency.txt && echo 10 > supervisor-docker-check-frequency.txt && echo 10 > supervisor-mqtt-check-frequency.txt" || exit 1

    echo ""

    echo "Checking deployment..."
    bash check-deployment.sh || exit 1

    echo ""
    echo "Finished deploying update"
  else
    echo "  GrowSense isn't installed. Skipping update."
  fi


else
  echo "You're not in the dev branch. Skipping dev deployment."
fi
