echo "Ongoing supervisor..."

IS_RUNNING=1

SLEEP_TIME=10

i=1

while [ $IS_RUNNING ]
do
  echo "  Loop: $i"
    
  bash supervise.sh $i
  
  echo "  Sleeping for $SLEEP_TIME seconds..."
  sleep $SLEEP_TIME
  
  ((i++))
done
