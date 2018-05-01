DIR=$PWD

DEVICE_NUMBER=$1
DEVICE_TYPE=$2
DEVICE_NAME=$3
DEVICE_LABEL=$4
DEVICE_PORT=$5

if [ ! $DEVICE_NUMBER ]; then
  echo "Specify device number as an argument."
  exit 1
fi

if [ ! $DEVICE_TYPE ]; then
  echo "Specify device type as an argument."
  exit 1
fi

if [ ! $DEVICE_NAME ]; then
  echo "Specify device name as an argument."
  exit 1
fi

if [ ! $DEVICE_LABEL ]; then
  echo "Specify device label as an argument."
  exit 1
fi

if [ ! $DEVICE_PORT ]; then
  echo "Specify device port as an argument."
  exit 1
fi

echo "Device label: $DEVICE_LABEL"
echo "Device name: $DEVICE_NAME"
echo "Device port: $DEVICE_PORT"

CALIBRATED_TOPIC="/$DEVICE_NAME/C"
NEW_LINEAR_MQTT_SETTINGS_FILE="mobile/linearmqtt/newsettings.json"

echo "" && \
echo "Verify Linear MQTT UI configuration..." && \

#echo "" && \
#echo "New settings file content:" && \
#echo "--------------------" && \
#jq . $NEW_LINEAR_MQTT_SETTINGS_FILE && \
#echo "--------------------" && \
#echo "" && \

echo "" && \
echo "Checking summary element" && \

SUMMARY_ELEMENT=$(jq -r '.dashboards[0].dashboard[0]' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ "$SUMMARY_ELEMENT" = "null" ]; then
  echo "  Summary element not found"
  exit 1
else
  echo "  Summary element found"
fi

#echo "---------- SUMMARY_ELEMENT"
#echo "$SUMMARY_ELEMENT"
#echo "----------"

echo "" && \
echo "Checking summary element name" && \

SUMMARY_NAME=$(jq -r '.dashboards[0].dashboard[0].name' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$SUMMARY_NAME" = "$DEVICE_LABEL" ]; then
  echo "  Summary element name is incorrect. Expected '$DEVICE_LABEL' but was '$SUMMARY_NAME'."
  exit 1
else
  echo "  Summary element name is correct"
fi

#echo "---------- SUMMARY_NAME"
#echo "$SUMMARY_NAME"
#echo "----------"

echo "" && \
echo "Checking summary element topic" && \

SUMMARY_TOPIC=$(jq -r '.dashboards[0].dashboard[0].topic' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$SUMMARY_TOPIC" = "$CALIBRATED_TOPIC" ]; then
  echo "  Summary topic is incorrect. It is '$SUMMARY_TOPIC' but '$CALIBRATED_TOPIC' was expected."
  exit 1
else
  echo "  Summary topic is correct"
fi

#echo "---------- SUMMARY_TOPIC"
#echo "$SUMMARY_TOPIC"
#echo "----------"

echo "" && \
echo "Checking device tab" && \

DEVICE_TAB=$(jq -r '.tabs[1]' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$DEVICE_TAB" = "null" ]; then
  echo "  Device tab found"
else
  echo "  Device tab not found"
  exit 1
fi

#echo "---------- DEVICE_TAB"
#echo "$DEVICE_TAB"
#echo "----------"

echo "" && \
echo "Checking device tab name" && \

DEVICE_TAB_NAME=$(jq -r '.tabs[1].name' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ "$DEVICE_TAB_NAME" = "null" ]; then
 echo "   Invalid device tab name. Expected '$DEVICE_LABEL' but was '$DEVICE_TAB_NAME'."
 exit 1
else
  echo "  Device tab name is correct"
fi

#echo "---------- DEVICE_TAB_NAME"
#echo "$DEVICE_TAB_NAME"
#echo "----------"

echo "" && \
echo "Checking device dashboard" && \

DEVICE_DASHBOARD=$(jq -r '.dashboards[1]' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$DEVICE_DASHBOARD" = "null" ]; then
  echo "  Device dashboard found"
else
  echo "  Device dashboard not found."
  exit 1
fi

#echo "---------- DEVICE_DASHBOARD"
#echo "$DEVICE_DASHBOARD"
#echo "----------"

echo "" && \
echo "Checking device dashboard id" && \

DEVICE_DASHBOARD_ID=$(jq -r '.dashboards[1].id' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ "$DEVICE_DASHBOARD_ID" = "2" ]; then
  echo "  Device dashboard ID is valid."
else
  echo "  Device dashboard ID is invalid. Expected '2' but was '$DEVICE_DASHBOARD_ID'."
  exit 1
fi

#echo "---------- DEVICE_DASHBOARD_ID"
#echo "$DEVICE_DASHBOARD_ID"
#echo "----------"

echo "" && \
echo "Checking device dashboard calibrated entry" && \

DEVICE_DASHBOARD_CALIBRATED_ENTRY=$(jq -r '.dashboards[1].dashboard[0]' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$DEVICE_DASHBOARD_CALIBRATED_ENTRY" = "null" ]; then
  echo "  Device dashboard calibrated entry found"
else
  echo "  Device dashboard calibrated entry not found."
  exit 1
fi

#echo "---------- DEVICE_DASHBOARD_CALIBRATED_ENTRY_NAME"
#echo "$DEVICE_DASHBOARD_CALIBRATED_ENTRY_NAME"
#echo "----------"

echo "" && \
echo "Checking device dashboard calibrated entry topic" && \

# This is a hack to work around the fact that the irrigator tab has the "pump is on" element first, and the calibrated value is second (with the index of 1)
# TODO: Should the UI be changed so this hack isn't needed?
CALIBRATED_ELEMENT_INDEX=0
if [ "$DEVICE_TYPE" = "irrigator" ]; then
    CALIBRATED_ELEMENT_INDEX=1
fi

DEVICE_DASHBOARD_CALIBRATED_ENTRY_TOPIC=$(jq -r ".dashboards[1].dashboard[$CALIBRATED_ELEMENT_INDEX].topic" $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ "$DEVICE_DASHBOARD_CALIBRATED_ENTRY_TOPIC" = "$CALIBRATED_TOPIC" ]; then
  echo "  Device dashboard calibrated entry topic is correct"
else
  echo "  Device dashboard calibrated entry topic is incorrect. Expected '$CALIBRATED_TOPIC' but was '$DEVICE_DASHBOARD_CALIBRATED_ENTRY_TOPIC'."
  exit 1
fi

echo "Linear MQTT device UI verified."