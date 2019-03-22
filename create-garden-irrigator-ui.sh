echo ""
echo "Creating garden irrigator configuration"
echo ""

# Example:
# sh create-garden-irrigator-ui.sh [Label] [DeviceName]
# sh create-garden-irrigator-ui.sh MyIrrigator myirrigator

DIR=$PWD
DEVICE_EXISTS=false

DEVICE_LABEL=$1
DEVICE_NAME=$2

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="Irrigator1"
fi
if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="irrigator1"
fi

DEVICE_INFO_DIR="devices/$DEVICE_NAME"


IS_DEVICE_UI_CREATED_FLAG_FILE="$DEVICE_INFO_DIR/is-ui-created.txt"
IS_DEVICE_UI_CREATED=0
if [ -f $IS_DEVICE_UI_CREATED_FLAG_FILE ]; then
  IS_DEVICE_UI_CREATED=$(cat "$IS_DEVICE_UI_CREATED_FLAG_FILE")
fi

if [ $IS_DEVICE_UI_CREATED = 1 ]; then
  DEVICE_EXISTS=true
fi


if [ $DEVICE_EXISTS = false ]; then
  cd "mobile/linearmqtt/"

  sh increment-device-count.sh

  echo "Device label: $DEVICE_LABEL"
  echo "Device name: $DEVICE_NAME"

  DEVICE_COUNT=$(cat devicecount.txt) && \
  DEVICE_ID=$(($DEVICE_COUNT+1)) && \

  echo "Device number: $DEVICE_COUNT" && \

  # Irrigator tab

  IRRIGATOR_TAB=$(cat parts/irrigatortab.json)

  IRRIGATOR_TAB=$(echo $IRRIGATOR_TAB | sed "s/Irrigator1/$DEVICE_LABEL/g") && \
  IRRIGATOR_TAB=$(echo $IRRIGATOR_TAB | sed "s/irrigator1/$DEVICE_NAME/g") && \

  IRRIGATOR_TAB=$(echo $IRRIGATOR_TAB | jq .id=$DEVICE_ID) && \

  NEW_SETTINGS=$(jq ".tabs[$DEVICE_COUNT] |= . + $IRRIGATOR_TAB" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \

  # Irrigator summary

  IRRIGATOR_SUMMARY=$(cat parts/irrigatorsummary.json) && \

  IRRIGATOR_SUMMARY=$(echo $IRRIGATOR_SUMMARY | sed "s/Irrigator1/$DEVICE_LABEL/g") && \
  IRRIGATOR_SUMMARY=$(echo $IRRIGATOR_SUMMARY | sed "s/irrigator1/$DEVICE_NAME/g") && \

  #IRRIGATOR_SUMMARY=$(echo $IRRIGATOR_SUMMARY | jq .id=$DEVICE_ID) && \

  NEW_SETTINGS=$(jq ".dashboards[0].dashboard[$(($DEVICE_COUNT-1))] |= . + $IRRIGATOR_SUMMARY" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \


  # Irrigator dashboard

  IRRIGATOR_DASHBOARD=$(cat parts/irrigatordashboard.json) && \

  IRRIGATOR_DASHBOARD=$(echo $IRRIGATOR_DASHBOARD | sed "s/Irrigator1/$DEVICE_LABEL/g") && \
  IRRIGATOR_DASHBOARD=$(echo $IRRIGATOR_DASHBOARD | sed "s/irrigator1/$DEVICE_NAME/g") && \

  #IRRIGATOR_DASHBOARD=$(echo $IRRIGATOR_DASHBOARD | jq .id=$DEVICE_ID) && \

  NEW_SETTINGS=$(jq ".dashboards[$DEVICE_COUNT] |= . + $IRRIGATOR_DASHBOARD" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \

  NEW_SETTINGS=$(jq ".dashboards[$DEVICE_COUNT].id=\"$DEVICE_ID\"" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \

  echo 1 > $IS_DEVICE_UI_CREATED_FLAG_FILE

  sh package.sh || exit 1
else
  echo "Device already exists. Skipping UI creation."
fi


cd $DIR && \

echo "Finished creating irrigator UI"
