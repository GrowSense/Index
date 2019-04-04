echo "Ongoing supervisor..."

SLEEP_TIME=600

echo "Waiting for $SLEEP_TIME seconds before starting loop..."

sleep $SLEEP_TIME

sh supervise.sh

sh supervise-ongoing.sh
