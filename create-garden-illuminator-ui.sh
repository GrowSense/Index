echo ""
echo "Creating garden illuminator configuration"
echo ""

# Example:
# sh create-garden-illuminator-ui.sh [Label] [DeviceName]
# sh create-garden-illuminator-ui.sh MyIlluminator myilluminator

DIR=$PWD
DEVICE_EXISTS=false

DEVICE_LABEL=$1
DEVICE_NAME=$2

if [ ! $DEVICE_LABEL ]; then
  echo "Provide a label as an argument."
  exit 1
fi
if [ ! $DEVICE_NAME ]; then
  echo "Provide a name as an argument."
  exit 1
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

  # Illuminator tab

  ILLUMINATOR_TAB=$(cat parts/illuminatortab.json)

  ILLUMINATOR_TAB=$(echo $ILLUMINATOR_TAB | sed "s/Illuminator1/$DEVICE_LABEL/g") && \
  ILLUMINATOR_TAB=$(echo $ILLUMINATOR_TAB | sed "s/illuminator1/$DEVICE_NAME/g") && \

  ILLUMINATOR_TAB=$(echo $ILLUMINATOR_TAB | jq .id=$DEVICE_ID) && \

  NEW_SETTINGS=$(jq ".tabs[$DEVICE_COUNT] |= . + $ILLUMINATOR_TAB" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \

  # Illuminator summary

  ILLUMINATOR_SUMMARY=$(cat parts/illuminatorsummary.json) && \

  ILLUMINATOR_SUMMARY=$(echo $ILLUMINATOR_SUMMARY | sed "s/Illuminator1/$DEVICE_LABEL/g") && \
  ILLUMINATOR_SUMMARY=$(echo $ILLUMINATOR_SUMMARY | sed "s/illuminator1/$DEVICE_NAME/g") && \

  #ILLUMINATOR_SUMMARY=$(echo $ILLUMINATOR_SUMMARY | jq .id=$DEVICE_ID) && \

  NEW_SETTINGS=$(jq ".dashboards[0].dashboard[$(($DEVICE_COUNT-1))] |= . + $ILLUMINATOR_SUMMARY" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \


  # Illuminator dashboard

  ILLUMINATOR_DASHBOARD=$(cat parts/illuminatordashboard.json) && \

  ILLUMINATOR_DASHBOARD=$(echo $ILLUMINATOR_DASHBOARD | sed "s/Illuminator1/$DEVICE_LABEL/g") && \
  ILLUMINATOR_DASHBOARD=$(echo $ILLUMINATOR_DASHBOARD | sed "s/illuminator1/$DEVICE_NAME/g") && \

  #ILLUMINATOR_DASHBOARD=$(echo $ILLUMINATOR_DASHBOARD | jq .id=$DEVICE_ID) && \

  NEW_SETTINGS=$(jq ".dashboards[$DEVICE_COUNT] |= . + $ILLUMINATOR_DASHBOARD" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \

  NEW_SETTINGS=$(jq ".dashboards[$DEVICE_COUNT].id=\"$DEVICE_ID\"" newsettings.json) && \

  echo $NEW_SETTINGS > newsettings.json && \

  sh package.sh && \
  
  cd $DIR && \
  
  sh set-garden-device-ui-created.sh $DEVICE_NAME
else
  echo "Device already exists. Skipping UI creation."
fi

echo "Finished creating illuminator UI"
