echo "Waiting for plug and play to register all devices..."

IS_FINISHED=0

MAX_LOOPS=100

CURRENT_LOOP=0

SLEEP_TIME=5

while [ $IS_FINISHED = 0 ]; do

  CURRENT_LOOP=$((CURRENT_LOOP+1))

  echo "  Loop: $CURRENT_LOOP"

  PNP_RESULT=$(systemctl status arduino-plug-and-play.service)

  echo "${PNP_RESULT}"

  [[ ! $(echo $PNP_RESULT) =~ "Loaded: loaded" ]] && echo "Arduino Plug and Play service isn't loaded" && exit 1
  [[ ! $(echo $PNP_RESULT) =~ "Active: active" ]] && echo "Arduino Plug and Play service isn't active" && exit 1
  [[ $(echo $PNP_RESULT) =~ "not found" ]] && echo "Arduino Plug and Play service wasn't found" && exit 1
  [[ $(echo $PNP_RESULT) =~ "dead" ]] && echo "Arduino Plug and Play service is dead" && exit 1

  [[ $(echo $PNP_RESULT) =~ "(existing)" ]] && [[ ! $(echo $PNP_RESULT) =~ "(new)" ]] && [[ ! $(echo $PNP_RESULT) =~ "processes queued" ]] && echo "  Plug and play is finished registering devices." && IS_FINISHED=1
  [[ $(echo $PNP_RESULT) =~ "No devices detected" ]] && echo "  Plug and play is finished registering devices. No devices were detected" && IS_FINISHED=1

  [[ $CURRENT_LOOP = $MAX_LOOPS ]] && echo "  Reached the max number of loops" && IS_FINISHED=1

  echo "  Is finished: $IS_FINISHED"
  echo ""

  [[ $IS_FINISHED = 0 ]] && echo "Sleeping for $SLEEP_TIME seconds..." && sleep $SLEEP_TIME
done

echo "Finished waiting for plug and play to register all devices"
