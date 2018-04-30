echo "----------" && \
echo "Testing irrigator scripts" && \
echo "----------" && \

IRRIGATOR_LABEL="MyIrrigator"
IRRIGATOR_DEVICE_NAME="myirrigator"
IRRIGATOR_PORT="ttyUSB1"
IRRIGATOR_CALIBRATED_TOPIC="/$IRRIGATOR_DEVICE_NAME/C"

NEW_LINEAR_MQTT_SETTINGS_FILE="mobile/linearmqtt/newsettings.json"

sh clean.sh

echo "" && \
echo "Creating garden irrigator services" && \
echo "" && \

sh create-garden-irrigator.sh $IRRIGATOR_LABEL $IRRIGATOR_DEVICE_NAME $IRRIGATOR_PORT && \

echo "" && \
echo "----------" && \
echo "Checking results" && \
echo "----------" && \

echo "" && \
#echo "New settings file content:" && \
#echo "--------------------" && \
#jq . $NEW_LINEAR_MQTT_SETTINGS_FILE && \
#echo "--------------------" && \
#echo "" && \

echo "" && \
echo "Checking linear MQTT irrigator summary element" && \

IRRIGATOR_SUMMARY_ELEMENT=$(jq -r '.dashboards[0].dashboard[0]' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ "$IRRIGATOR_SUMMARY_ELEMENT" = "null" ]; then
  echo "  Irrigator summary element not found"
  exit 1
else
  echo "  Irrigator summary element found"
fi

#echo "---------- IRRIGATOR_SUMMARY_ELEMENT"
#echo "$IRRIGATOR_SUMMARY_ELEMENT"
#echo "----------"

echo "" && \
echo "Checking linear MQTT irrigator summary name" && \

IRRIGATOR_SUMMARY_NAME=$(jq -r '.dashboards[0].dashboard[0].name' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$IRRIGATOR_SUMMARY_NAME" = "$IRRIGATOR_LABEL" ]; then
  echo "  Irrigator summary element name is incorrect. Expected '$IRRIGATOR_LABEL' but was '$IRRIGATOR_SUMMARY_NAME'."
  exit 1
else
  echo "  Irrigator summary element name is correct"
fi

#echo "---------- IRRIGATOR_SUMMARY_NAME"
#echo "$IRRIGATOR_SUMMARY_NAME"
#echo "----------"

echo "" && \
echo "Checking irrigator summary topic" && \

IRRIGATOR_SUMMARY_TOPIC=$(jq -r '.dashboards[0].dashboard[0].topic' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$IRRIGATOR_SUMMARY_TOPIC" = "$IRRIGATOR_CALIBRATED_TOPIC" ]; then
  echo "  Irrigator summary topic is incorrect. It is '$IRRIGATOR_SUMMARY_TOPIC' but '$IRRIGATOR_CALIBRATED_TOPIC' was expected."
  exit 1
else
  echo "  Irrigator summary topic is correct"
fi

#echo "---------- IRRIGATOR_SUMMARY_TOPIC"
#echo "$IRRIGATOR_SUMMARY_TOPIC"
#echo "----------"

echo "" && \
echo "Checking linear MQTT irrigator tab" && \

IRRIGATOR_TAB=$(jq -r '.tabs[1]' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$IRRIGATOR_TAB" = "null" ]; then
  echo "  Irrigator tab found"
else
  echo "  Irrigator tab not found"
  exit 1
fi

#echo "---------- IRRIGATOR_TAB"
#echo "$IRRIGATOR_TAB"
#echo "----------"

echo "" && \
echo "Checking linear MQTT irrigator tab name" && \

IRRIGATOR_TAB_NAME=$(jq -r '.tabs[1].name' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ "$IRRIGATOR_TAB_NAME" = "null" ]; then
 echo "   Invalid irrigator name name. Expected '$IRRIGATOR_LABEL' but was '$IRRIGATOR_TAB_NAME'."
 exit 1
else
  echo "  Irrigator tab name is correct"
fi

#echo "---------- IRRIGATOR_TAB_NAME"
#echo "$IRRIGATOR_TAB_NAME"
#echo "----------"

echo "" && \
echo "Checking linear MQTT irrigator dashboard" && \

IRRIGATOR_DASHBOARD=$(jq -r '.dashboards[1]' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$IRRIGATOR_DASHBOARD" = "null" ]; then
  echo "  Irrigator dashboard found"
else
  echo "  Irrigator dashboard not found."
  exit 1
fi

#echo "---------- IRRIGATOR_DASHBOARD"
#echo "$IRRIGATOR_DASHBOARD"
#echo "----------"


echo "" && \
echo "Checking linear MQTT irrigator dashboard id" && \

IRRIGATOR_DASHBOARD_ID=$(jq -r '.dashboards[1].id' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ "$IRRIGATOR_DASHBOARD_ID" = "2" ]; then
  echo "  Irrigator dashboard ID is valid."
else
  echo "  Irrigator dashboard ID is invalid. Expected '2' but was '$IRRIGATOR_DASHBOARD_ID'."
  exit 1
fi

echo "" && \
echo "Checking linear MQTT irrigator dashboard calibrated entry" && \

IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY=$(jq -r '.dashboards[1].dashboard[0]' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY" = "null" ]; then
  echo "  Irrigator dashboard calibrated entry found"
else
  echo "  Irrigator dashboard calibrated entry not found."
  exit 1
fi

echo "" && \
echo "Checking linear MQTT irrigator dashboard calibrated entry topic" && \

IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY_TOPIC=$(jq -r '.dashboards[1].dashboard[1].topic' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ "$IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY_TOPIC" = "$IRRIGATOR_CALIBRATED_TOPIC" ]; then
  echo "  Irrigator dashboard calibrated entry topic is correct"
else
  echo "  Irrigator dashboard calibrated entry topic is incorrect."
  exit 1
fi

echo "Irrigator test complete"