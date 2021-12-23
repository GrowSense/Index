DIR=$PWD

rm releases/ -R

bash build-cli.sh || exit 1
bash create-release-zip.sh || exit 1

cd releases

FILES="*"
for f in $FILES
do
  echo "    $f"
  RELEASE_FILE=$f
done

cd $DIR

echo "releases/$RELEASE_FILE"


echo ""

. ./detect-deployment-details.sh

echo "Testing deploy..."


sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash stop-garden.sh && rm /usr/local/GrowSense/Installer/GrowSenseIndex.zip && rm /usr/local/GrowSense/Index/ -R && rm /usr/local/ArduinoPlugAndPlay/ -R"

mv releases/$RELEASE_FILE releases/GrowSenseIndex.zip

scp releases/* $INSTALL_SSH_USERNAME@$INSTALL_HOST:/usr/local/GrowSense/Installer/


BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Installer/$BRANCH/scripts-download/download-installer.sh | bash -s -- --branch=$BRANCH --to=/usr/local/ --version=$(cat full-version.txt) --allow-skip-download=true || exit 1" || exit 1

DEPLOYED_VERSION=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cat /usr/local/GrowSense/Index/full-version.txt")
CURRENT_VERSION=$(cat full-version.txt)

#if [ "$DEPLOYED_VERSON" != "$CURRENT_VERSION" ]; then
#  echo "Versions don't match..."
#  echo "  Current version: $CURRENT_VERSION"
#  echo "  Deployed version: $DEPLOYED_VERSION"
#  exit 1	
#fi

echo ""
echo "Setting GrowSense config values..."
  
sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash gs.sh config --wifi-name=$WIFI_NAME --wifi-password=$WIFI_PASSWORD --mqtt-host=$INSTALL_MQTT_HOST --mqtt-username=$INSTALL_MQTT_USERNAME --mqtt-password=$INSTALL_MQTT_PASSWORD --mqtt-port=$INSTALL_MQTT_PORT --smtp-server=$SMTP_SERVER --email=$EMAIL_ADDRESS --smtp-username=$SMTP_USERNAME --smtp-password=$SMTP_PASSWORD --smtp-port=$SMTP_PORT || exit 1" || exit 1

echo ""
echo "Verifying installation..."
sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash gs.sh verify || exit 1" || exit 1


echo ""
echo "Setting supervisor settings..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index/ && echo 10 > supervisor-status-check-frequency.txt && echo 10 > supervisor-docker-check-frequency.txt && echo 10 > supervisor-mqtt-check-frequency.txt" || exit 1

echo ""
echo "Checking deployment..."
bash check-deployment.sh || exit 1
 
