echo "Upgrading..."

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

echo ""
echo "  Branch: $BRANCH"

echo ""
echo "  Caching repository/updating cache...."
bash cache-repository.sh $BRANCH

if [ $? == 0 ]; then
  echo ""
  echo "  Upgrading device sketches..."
  bash upgrade-garden-device-sketches.sh
fi

if [ $? == 0 ]; then
  echo ""
  echo "  Upgrading system sketches..."
  bash upgrade-system.sh
fi

if [ $? != 0 ]; then
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
  bash send-email.sh "GrowSense system upgrade failed (on $HOST)" "The GrowSense system upgrade failed on $HOST...\n\nPrevious version: $INSTALLED_VERSION\nNew version: $LATEST_FULL_VERSION\n\nLog output...\n\n$(cat logs/updates/system.txt)"

  echo ""
  echo ""
else
  echo "Finished upgrade."
fi


