echo "Ongoing mesh manager..."

IS_RUNNING=1

SLEEP_TIME=$(cat mesh-manager-sleep-time.txt)

i=0

while [ $IS_RUNNING ]
do
  echo "  Loop: $i"
    
  bash manage-mesh.sh $i
  
  echo "  Sleeping for $SLEEP_TIME seconds..."
  sleep $SLEEP_TIME
  
  ((i++))
done
