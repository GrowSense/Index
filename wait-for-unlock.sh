echo "Waiting for system to unlock..."

MAX_RETRIES=100

SLEEP_TIME=3

echo "  Max retries: $MAX_RETRIES"
echo "  Sleep time: $SLEEP_TIME"

IS_LOCKED=1

LOOP_NUMBER=0

KEEP_WAITING=1

while [ "$KEEP_WAITING" == "1" ]
do
  echo ""
  echo "  Loop number: $LOOP_NUMBER"
  
  echo "  Executing check lock script on deployment host..."
  CHECK_LOCK_RESULT=$(bash check-lock.sh) || exit 1
      
  echo ""
  echo "${CHECK_LOCK_RESULT}"
  echo ""

  if [[ $(echo $CHECK_LOCK_RESULT) =~ "System free" ]]; then
    IS_LOCKED=0
  else
    IS_LOCKED=1
  fi
  
  if [ $IS_LOCKED = 1 ]; then
    echo "  System is locked"
  else
    echo "  System is unfree"
  fi
  
  if [ $IS_LOCKED = 0 ]; then
    KEEP_WAITING=0
  fi
  
  if [ $LOOP_NUMBER -gt $MAX_RETRIES ]; then
    KEEP_WAITING=0
  fi
  
  if [ "$KEEP_WAITING" == "1" ]; then
    echo "  Sleeping for $SLEEP_TIME seconds before retrying..."
    sleep $SLEEP_TIME
    
    if [[ "$LOOP_NUMBER" == "$MAX_RETRIES" ]]; then
      echo "  Reached maximum retry count."
      KEEP_WAITING=0
    fi
    
    LOOP_NUMBER=$((LOOP_NUMBER+1))
  fi
  
  echo ""
done

echo "Finished waiting for deployment to unlock"

