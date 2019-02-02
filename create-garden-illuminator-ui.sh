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
  DEVICE_LABEL="Illuminator1"
fi
if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="illuminator1"
fi

DEVICE_INFO_DIR="devices/$DEVICE_NAME"
if [ -d "$DEVICE_INFO_DIR" ]; then
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

  sh package.sh
else
  echo "Device already exists. Skipping UI creation."
fi


cd $DIR && \

echo "Finished creating illuminator UI"
