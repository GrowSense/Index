#!/bin/bash

echo "Checking status of deployment..."

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "master" ]; then
  echo "Master deployment on live garden..."
  INSTALL_HOST=$MASTER_INSTALL_HOST
  INSTALL_SSH_USERNAME=$MASTER_INSTALL_SSH_USERNAME
  INSTALL_SSH_PASSWORD=$MASTER_INSTALL_SSH_PASSWORD
  INSTALL_SSH_PORT=$MASTER_INSTALL_SSH_PORT
fi
if [ "$BRANCH" = "dev" ]; then
  echo "Dev deployment on staging garden..."
  INSTALL_HOST=$DEV_INSTALL_HOST
  INSTALL_SSH_USERNAME=$DEV_INSTALL_SSH_USERNAME
  INSTALL_SSH_PASSWORD=$DEV_INSTALL_SSH_PASSWORD
  INSTALL_SSH_PORT=$DEV_INSTALL_SSH_PORT
fi

echo "Viewing arduino plug and play service status..."

PNP_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status arduino-plug-and-play.service" || (echo "Error attempting to view arduino plug and play status." && exit 1))

[[ $(echo $PNP_RESULT) =~ "Loaded: loaded" ]] || (echo "Arduino Plug and Play service isn't loaded" && exit 1)
[[ $(echo $PNP_RESULT) =~ "Active: active" ]] || (echo "Arduino Plug and Play service isn't active" && exit 1)
[[ $(echo $PNP_RESULT) =~ "not found" ]] && (echo "Arduino Plug and Play service wasn't found" && exit 1)

echo "Viewing GreenSense supervisor service status..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-supervisor.service" || (echo "Error attempting to view garden supervisor status." && exit 1)

echo "Viewing GreenSense UI controller service status..."

UI_CONTOLLER_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-ui-1602-ui1.service" || (echo "Error attempting to view UI controller status." && exit 1))

[[ ! $(echo $UI_CONTOLLER_RESULT) =~ "Loaded: loaded" ]] && echo "The UI controller service isn't loaded" && exit 1
[[ ! $(echo $UI_CONTOLLER_RESULT) =~ "Active: active" ]] && echo "The UI controller service isn't active" && exit 1
[[ $(echo $UI_CONTOLLER_RESULT) =~ "not found" ]] && echo "The UI controller service wasn't found" && exit 1


echo "Viewing garden status..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GreenSense/Index; sh view-garden.sh" || (echo "Error attempting to view garden status." && exit 1)

echo "Finished checking status of deployment."
