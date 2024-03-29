
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

echo ""
echo "Detecting deployment details..."

if [ -f "set-deployment-details.sh.security" ]; then
  echo "  Found set-deployment-details.sh.security script. Executing."
  . ./set-deployment-details.sh.security
fi

if [ "$BRANCH" = "lts" ]; then
  echo "  Garden: lts"
  INSTALL_HOST=$LTS_INSTALL_HOST
  INSTALL_SSH_USERNAME=$LTS_INSTALL_SSH_USERNAME
  INSTALL_SSH_PASSWORD=$LTS_INSTALL_SSH_PASSWORD
  INSTALL_SSH_PORT=$LTS_INSTALL_SSH_PORT
  INSTALL_MQTT_HOST=$LTS_MQTT_HOST
  INSTALL_MQTT_USERNAME=$LTS_MQTT_USERNAME
  INSTALL_MQTT_PASSWORD=$LTS_MQTT_PASSWORD
  INSTALL_MQTT_PORT=$LTS_MQTT_PORT
fi
if [ "$BRANCH" = "rc" ]; then
  echo "  Garden: rc"
  INSTALL_HOST=$RC_INSTALL_HOST
  INSTALL_SSH_USERNAME=$RC_INSTALL_SSH_USERNAME
  INSTALL_SSH_PASSWORD=$RC_INSTALL_SSH_PASSWORD
  INSTALL_SSH_PORT=$RC_INSTALL_SSH_PORT
  INSTALL_MQTT_HOST=$RC_MQTT_HOST
  INSTALL_MQTT_USERNAME=$RC_MQTT_USERNAME
  INSTALL_MQTT_PASSWORD=$RC_MQTT_PASSWORD
  INSTALL_MQTT_PORT=$RC_MQTT_PORT
fi
if [ "$BRANCH" = "master" ]; then
  echo "  Garden: master"
  INSTALL_HOST=$MASTER_INSTALL_HOST
  INSTALL_SSH_USERNAME=$MASTER_INSTALL_SSH_USERNAME
  INSTALL_SSH_PASSWORD=$MASTER_INSTALL_SSH_PASSWORD
  INSTALL_SSH_PORT=$MASTER_INSTALL_SSH_PORT
  INSTALL_MQTT_HOST=$MASTER_MQTT_HOST
  INSTALL_MQTT_USERNAME=$MASTER_MQTT_USERNAME
  INSTALL_MQTT_PASSWORD=$MASTER_MQTT_PASSWORD
  INSTALL_MQTT_PORT=$MASTER_MQTT_PORT
fi
if [ "$BRANCH" = "dev" ]; then
  echo "  Garden: dev"
  INSTALL_HOST=$DEV_INSTALL_HOST
  INSTALL_SSH_USERNAME=$DEV_INSTALL_SSH_USERNAME
  INSTALL_SSH_PASSWORD=$DEV_INSTALL_SSH_PASSWORD
  INSTALL_SSH_PORT=$DEV_INSTALL_SSH_PORT
  INSTALL_MQTT_HOST=$DEV_MQTT_HOST
  INSTALL_MQTT_USERNAME=$DEV_MQTT_USERNAME
  INSTALL_MQTT_PASSWORD=$DEV_MQTT_PASSWORD
  INSTALL_MQTT_PORT=$DEV_MQTT_PORT
fi


echo "  Install host: $INSTALL_HOST"
echo "    SSH username: $INSTALL_SSH_USERNAME"
echo "    SSH password: [hidden]"
echo "    SSH port: $INSTALL_SSH_PORT"
echo "  MQTT host: $INSTALL_MQTT_HOST"
echo "   MQTT username: $INSTALL_MQTT_USERNAME"
echo "   MQTT password: [hidden]"
echo "   MQTT port: $INSTALL_MQTT_PORT"

echo "  Finished detecting deployment details."
echo ""
