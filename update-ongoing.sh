echo "Ongoing updater..."

SLEEP_TIME=10

sh update.sh

sh update-garden-device-sketches.sh

sleep $SLEEP_TIME

sh update-ongoing.sh
