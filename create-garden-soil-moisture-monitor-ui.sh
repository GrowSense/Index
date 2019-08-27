echo ""
echo "Creating garden monitor configuration"
echo ""

DIR=$PWD

# Example:
# sh create-garden-monitor-ui.sh [Label] [DeviceName]
# sh create-garden-monitor-ui.sh MyMonitor mymonitor

PROJECT_DIR=$PWD
DEVICE_EXISTS=false

DEVICE_LABEL=$1
DEVICE_NAME=$2

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="Monitor1"
fi
if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="monitor1"
fi


NEW_LINEAR_MQTT_SETTINGS_FILE="newsettings.json"

# Check if the device is registered in the UI
[ -f "devices/$DEVICE_NAME/is-ui-created.txt" ] \
  && [ $(cat "devices/$DEVICE_NAME/is-ui-created.txt") = 1 ] \
  && DEVICE_EXISTS=1 \
  || DEVICE_EXISTS=0

# If the device doesn't exist then add it
if [ $DEVICE_EXISTS = 0 ]; then

  cd "mobile/linearmqtt/"

  sh increment-device-count.sh

  echo "Device label: $DEVICE_LABEL"
  echo "Device name: $DEVICE_NAME"

  DEVICE_COUNT=$(cat devicecount.txt) && \
  DEVICE_ID=$(($DEVICE_COUNT+1)) && \

  echo "Device number: $DEVICE_COUNT" && \

  echo ""
  echo "Setting up json"

  # Monitor tab

  MONITOR_TAB=$(cat parts/monitortab.json) && \

#  echo "---------- Monitor Tab: Before"
#  echo $MONITOR_TAB
#  echo "----------"

  MONITOR_TAB=$(echo $MONITOR_TAB | sed "s/Monitor1/$DEVICE_LABEL/g") && \
  MONITOR_TAB=$(echo $MONITOR_TAB | sed "s/monitor1/$DEVICE_NAME/g") && \

  MONITOR_TAB=$(echo $MONITOR_TAB | jq .id=$DEVICE_ID) && \

#  echo "---------- Monitor Tab: After"
#  echo $MONITOR_TAB
#  echo "----------"

  NEW_SETTINGS=$(jq ".tabs[$DEVICE_COUNT] |= . + $MONITOR_TAB" $NEW_LINEAR_MQTT_SETTINGS_FILE) && \

  echo $NEW_SETTINGS > $NEW_LINEAR_MQTT_SETTINGS_FILE && \

  # Monitor summary

  MONITOR_SUMMARY=$(cat parts/monitorsummary.json) && \

#  echo "---------- Monitor Summary: Before"
#  echo $MONITOR_SUMMARY
#  echo "----------"

  MONITOR_SUMMARY=$(echo $MONITOR_SUMMARY | sed "s/Monitor1/$DEVICE_LABEL/g") && \
  MONITOR_SUMMARY=$(echo $MONITOR_SUMMARY | sed "s/monitor1/$DEVICE_NAME/g") && \

  #echo "---------- Monitor Summary: After"
  #echo $MONITOR_SUMMARY
  #echo "----------"

  DEVICE_INDEX=$(($DEVICE_COUNT-1))

  echo "Device index: $DEVICE_INDEX"

  NEW_SETTINGS=$(jq ".dashboards[0].dashboard[$(($DEVICE_INDEX))] |= . + $MONITOR_SUMMARY" $NEW_LINEAR_MQTT_SETTINGS_FILE) && \

  echo $NEW_SETTINGS > $NEW_LINEAR_MQTT_SETTINGS_FILE && \

  # Monitor dashboard

  MONITOR_DASHBOARD=$(cat parts/monitordashboard.json) && \

  #echo "---------- Monitor Dashboard: Before"
  #echo $MONITOR_DASHBOARD
  #echo "----------"

  MONITOR_DASHBOARD=$(echo $MONITOR_DASHBOARD | sed "s/Monitor1/$DEVICE_LABEL/g") && \
  MONITOR_DASHBOARD=$(echo $MONITOR_DASHBOARD | sed "s/monitor1/$DEVICE_NAME/g") && \

  #MONITOR_DASHBOARD=$(echo $MONITOR_DASHBOARD | jq .id="$DEVICE_ID") && \

  #echo "---------- Monitor Dashboard: After"
  #echo $MONITOR_DASHBOARD
  #echo "----------"

  NEW_SETTINGS=$(jq ".dashboards[$DEVICE_COUNT] |= . + $MONITOR_DASHBOARD" $NEW_LINEAR_MQTT_SETTINGS_FILE) && \

  echo $NEW_SETTINGS > newsettings.json && \

  NEW_SETTINGS=$(jq ".dashboards[$DEVICE_COUNT].id=\"$DEVICE_ID\"" $NEW_LINEAR_MQTT_SETTINGS_FILE) && \

  echo $NEW_SETTINGS > $NEW_LINEAR_MQTT_SETTINGS_FILE && \

  sh package.sh && \
  
  cd $DIR && \
  
  sh set-garden-device-ui-created.sh $DEVICE_NAME
else
  echo "Device already exists. Skipping UI creation."
fi

echo "Completed creation of garden monitor UI"
