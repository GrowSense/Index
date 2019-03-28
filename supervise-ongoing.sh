echo "Ongoing updater..."

SLEEP_TIME=120

sh supervise.sh

sleep $SLEEP_TIME

sh supervise-ongoing.sh
