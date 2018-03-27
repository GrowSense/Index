echo ""
echo "Creating garden monitor configuration"
echo ""

DIR=$PWD

DEVICE_LABEL=$1
DEVICE_NAME=$2

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="Monitor1"
fi
if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="monitor1"
fi

sh increment-device-count.sh

echo "Device label: $DEVICE_LABEL"
echo "Device name: $DEVICE_NAME"

DEVICE_COUNT=$(cat devicecount.txt) && \
DEVICE_ID=$(($DEVICE_COUNT+1)) && \

echo "Device number: $DEVICE_COUNT" && \

# Monitor tab

MONITOR_TAB=$(cat parts/monitortab.json) && \

MONITOR_TAB=$(echo $MONITOR_TAB | sed "s/Monitor1/$DEVICE_LABEL/g") && \
MONITOR_TAB=$(echo $MONITOR_TAB | sed "s/monitor1/$DEVICE_NAME/g") && \

MONITOR_TAB=$(echo $MONITOR_TAB | jq .id=$DEVICE_ID) && \

NEW_SETTINGS=$(jq ".tabs[$DEVICE_COUNT] |= . + $MONITOR_TAB" newsettings.json) && \

echo $NEW_SETTINGS > newsettings.json && \

# Monitor summary

MONITOR_SUMMARY=$(cat parts/monitorsummary.json) && \

MONITOR_SUMMARY=$(echo $MONITOR_SUMMARY | sed "s/Monitor1/$DEVICE_LABEL/g") && \
MONITOR_SUMMARY=$(echo $MONITOR_SUMMARY | sed "s/monitor1/$DEVICE_NAME/g") && \

MONITOR_SUMMARY=$(echo $MONITOR_SUMMARY | jq .id=$DEVICE_ID) && \

NEW_SETTINGS=$(jq ".dashboards[0].dashboard[$(($DEVICE_COUNT-1))] |= . + $MONITOR_SUMMARY" newsettings.json) && \

echo $NEW_SETTINGS > newsettings.json && \

# Monitor dashboard

MONITOR_DASHBOARD=$(cat parts/monitordashboard.json) && \

MONITOR_DASHBOARD=$(echo $MONITOR_DASHBOARD | sed "s/Monitor1/$DEVICE_LABEL/g") && \
MONITOR_DASHBOARD=$(echo $MONITOR_DASHBOARD | sed "s/monitor1/$DEVICE_NAME/g") && \

MONITOR_DASHBOARD=$(echo $MONITOR_DASHBOARD | jq .id=$DEVICE_ID) && \

NEW_SETTINGS=$(jq ".dashboards[$DEVICE_COUNT] |= . + $MONITOR_DASHBOARD" newsettings.json) && \

echo $NEW_SETTINGS > newsettings.json && \

sh package.sh && \

echo "Completed creation of garden monitor UI"
