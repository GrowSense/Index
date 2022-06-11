echo "Upgrading..."

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

echo ""
echo "  Branch: $BRANCH"

if [ -f "is-upgrading.txt" ]; then
  echo ""
  echo "  System upgrade is already under way... aborting upgrade."
  exit 0
fi

# TODO: Remove if not needed. Updates no longer happen using git so shouldn't be needed
#echo ""
#echo "  Updating repository...."
#bash update.sh

if [ "$?" -eq "0" ]; then
  echo ""
  echo "  Upgrading system..."
  bash upgrade-system.sh
fi

if [ "$?" -eq "0" ]; then
  echo ""
  echo "  Upgrading device sketches..."
  bash upgrade-garden-device-sketches.sh
fi

if [ "$?" -eq "0" ]; then
  echo ""
  echo "  Supervising device status..."
  STATUS_CHECK_FREQUENCY=$(cat supervisor-status-check-frequency.txt)

  bash supervise-devices.sh $STATUS_CHECK_FREQUENCY
fi

if [ "$?" -ne "0" ]; then
  echo ""
  echo "  Publishing status to MQTT..."
  bash mqtt-publish.sh "garden/StatusMessage" "Upgrade failed"

  echo ""
  echo "  Creating message file..."
  bash create-alert-file.sh "GrowSense system upgrade failed (v$LATEST_FULL_VERSION)"

  echo ""
  echo "Error: Upgrade failed."
  echo ""
  echo ""

  echo ""
  echo "  Sending email report..."
  bash send-email.sh "GrowSense system upgrade failed (on $HOST)" "The GrowSense system upgrade failed on $HOST...\n\nPrevious version: $INSTALLED_VERSION\nNew version: $LATEST_FULL_VERSION\n\nLog output...\n\n$(bash view-upgrade-service-log.sh)"


  echo ""
  echo ""
else
  echo ""
  echo "Finished upgrade."
fi

