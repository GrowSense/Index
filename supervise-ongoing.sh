echo "Ongoing updater..."

SLEEP_TIME=600

sh supervise.sh

echo "Waiting for $SLEEP_TIME seconds before repeating..."

sleep $SLEEP_TIME

sh supervise-ongoing.sh
