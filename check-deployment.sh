echo "Checking status of deployment..."

echo "Viewing arduino plug and play service status..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status arduino-plug-and-play.service"

echo "Viewing GreenSense supervisor service status..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-supervisor.service"

echo "Viewing garden status..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GreenSense/Index; sh view-garden.sh"

echo "Finished checking status of deployment."
