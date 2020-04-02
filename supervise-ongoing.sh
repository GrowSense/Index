echo "Ongoing supervisor..."

IS_RUNNING=1

SLEEP_TIME=$(cat supervisor-sleep-time.txt)

i=1

bash wait-for-plug-and-play.sh

while [ $IS_RUNNING ]
do
  echo "  Loop: $i"

  bash supervise.sh $i

  echo "  Sleeping for $SLEEP_TIME seconds..."
  sleep $SLEEP_TIME

  ((i++))
done
