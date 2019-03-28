echo "Ongoing updater..."

SLEEP_TIME=60

sh supervise.sh

sleep $SLEEP_TIME

sh supervise-ongoing.sh
