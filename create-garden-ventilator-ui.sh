echo ""
echo "Creating garden ventilator configuration"
echo ""

# Example:
# sh create-garden-ventilator-ui.sh [Label] [DeviceName]
# sh create-garden-ventilator-ui.sh MyVentilator myventilator

DIR=$PWD

DEVICE_EXISTS=false

DEVICE_LABEL=$1
DEVICE_NAME=$2

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="Ventilator1"
fi
if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="ventilator1"
fi

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

  # Ventilator tab

  VENTILATOR_TAB=$(cat parts/ventilatortab.json)

  VENTILATOR_TAB=$(echo $VENTILATOR_TAB | sed "s/Ventilator1/$DEVICE_LABEL/g") && \
  VENTILATOR_TAB=$(echo $VENTILATOR_TAB | sed "s/ventilator1/$DEVICE_NAME/g") && \

  VENTILATOR_TAB=$(echo $VENTILATOR_TAB | jq .id=$DEVICE_ID) && \

  NEW_SETTINGS=$(jq ".tabs[$DEVICE_COUNT] |= . + $VENTILATOR_TAB" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \

  # Ventilator summary

  VENTILATOR_SUMMARY=$(cat parts/ventilatorsummary.json) && \

  VENTILATOR_SUMMARY=$(echo $VENTILATOR_SUMMARY | sed "s/Ventilator1/$DEVICE_LABEL/g") && \
  VENTILATOR_SUMMARY=$(echo $VENTILATOR_SUMMARY | sed "s/ventilator1/$DEVICE_NAME/g") && \

  #VENTILATOR_SUMMARY=$(echo $VENTILATOR_SUMMARY | jq .id=$DEVICE_ID) && \

  NEW_SETTINGS=$(jq ".dashboards[0].dashboard[$(($DEVICE_COUNT-1))] |= . + $VENTILATOR_SUMMARY" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \


  # Ventilator dashboard

  VENTILATOR_DASHBOARD=$(cat parts/ventilatordashboard.json) && \

  VENTILATOR_DASHBOARD=$(echo $VENTILATOR_DASHBOARD | sed "s/Ventilator1/$DEVICE_LABEL/g") && \
  VENTILATOR_DASHBOARD=$(echo $VENTILATOR_DASHBOARD | sed "s/ventilator1/$DEVICE_NAME/g") && \

  #VENTILATOR_DASHBOARD=$(echo $VENTILATOR_DASHBOARD | jq .id=$DEVICE_ID) && \

  NEW_SETTINGS=$(jq ".dashboards[$DEVICE_COUNT] |= . + $VENTILATOR_DASHBOARD" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \

  NEW_SETTINGS=$(jq ".dashboards[$DEVICE_COUNT].id=\"$DEVICE_ID\"" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \

  sh package.sh && \
  
  cd $DIR && \
  
  sh set-garden-device-ui-created.sh $DEVICE_NAME
else
  echo "Device already exists. Skipping UI creation."
fi

echo "Finished creating ventilator UI"
