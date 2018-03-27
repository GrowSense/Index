echo ""
echo "Creating garden irrigator configuration"
echo ""

DIR=$PWD

DEVICE_LABEL=$1
DEVICE_NAME=$2

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="Irrigator1"
fi
if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="irrigator1"
fi

sh increment-device-count.sh

echo "Device label: $DEVICE_LABEL"
echo "Device name: $DEVICE_NAME"

DEVICE_COUNT=$(cat devicecount.txt)
DEVICE_ID=$(($DEVICE_COUNT+1))

echo "Device number: $DEVICE_COUNT"

# Irrigator tab

IRRIGATOR_TAB=$(cat parts/irrigatortab.json)

IRRIGATOR_TAB=$(echo $IRRIGATOR_TAB | sed "s/Irrigator1/$DEVICE_LABEL/g")
IRRIGATOR_TAB=$(echo $IRRIGATOR_TAB | sed "s/irrigator1/$DEVICE_NAME/g")

IRRIGATOR_TAB=$(echo $IRRIGATOR_TAB | jq .id=$DEVICE_ID)

NEW_SETTINGS=$(jq ".tabs[$DEVICE_COUNT] |= . + $IRRIGATOR_TAB" newsettings.json)

echo $NEW_SETTINGS > newsettings.json

# Irrigator summary

IRRIGATOR_SUMMARY=$(cat parts/irrigatorsummary.json)

IRRIGATOR_SUMMARY=$(echo $IRRIGATOR_SUMMARY | sed "s/Irrigator1/$DEVICE_LABEL/g")
IRRIGATOR_SUMMARY=$(echo $IRRIGATOR_SUMMARY | sed "s/irrigator1/$DEVICE_NAME/g")

IRRIGATOR_SUMMARY=$(echo $IRRIGATOR_SUMMARY | jq .id=$DEVICE_ID)

NEW_SETTINGS=$(jq ".dashboards[0].dashboard[$(($DEVICE_COUNT-1))] |= . + $IRRIGATOR_SUMMARY" newsettings.json)

echo $NEW_SETTINGS > newsettings.json


# Irrigator dashboard

IRRIGATOR_DASHBOARD=$(cat parts/irrigatordashboard.json)

IRRIGATOR_DASHBOARD=$(echo $IRRIGATOR_DASHBOARD | sed "s/Irrigator1/$DEVICE_LABEL/g")
IRRIGATOR_DASHBOARD=$(echo $IRRIGATOR_DASHBOARD | sed "s/irrigator1/$DEVICE_NAME/g")

IRRIGATOR_DASHBOARD=$(echo $IRRIGATOR_DASHBOARD | jq .id=$DEVICE_ID)

NEW_SETTINGS=$(jq ".dashboards[$DEVICE_COUNT] |= . + $IRRIGATOR_DASHBOARD" newsettings.json)

echo $NEW_SETTINGS > newsettings.json
