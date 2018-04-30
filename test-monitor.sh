echo "----------" && \
echo "Testing monitor scripts" && \
echo "----------" && \

MONITOR_LABEL="MyMonitor"
MONITOR_DEVICE_NAME="mymonitor"
MONITOR_PORT="ttyUSB0"
MONITOR_CALIBRATED_TOPIC="/$MONITOR_DEVICE_NAME/C"

NEW_LINEAR_MQTT_SETTINGS_FILE="mobile/linearmqtt/newsettings.json"

sh clean.sh

echo "" && \
echo "Creating garden monitor services" && \
echo "" && \

sh create-garden-monitor.sh $MONITOR_LABEL $MONITOR_DEVICE_NAME $MONITOR_PORT && \

echo "" && \
#echo "New settings file content:" && \
#echo "--------------------" && \
#jq . $NEW_LINEAR_MQTT_SETTINGS_FILE && \
#echo "--------------------" && \
#echo "" && \

echo "" && \
echo "----------" && \
echo "Checking results" && \
echo "----------" && \

echo "" && \
echo "Checking linear MQTT monitor summary element" && \

MONITOR_SUMMARY_ELEMENT=$(jq -r '.dashboards[0].dashboard[0]' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ "$MONITOR_SUMMARY_ELEMENT" = "null" ]; then
  echo "  Monitor sumary element not found"
  exit 1
else
  echo "  Monitor summary element found"
fi

#echo "---------- MONITOR_SUMMARY_ELEMENT"
#echo "$MONITOR_SUMMARY_ELEMENT"
#echo "----------"

echo "" && \
echo "Checking linear MQTT monitor summary name" && \

MONITOR_SUMMARY_NAME=$(jq -r '.dashboards[0].dashboard[0].name' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$MONITOR_SUMMARY_NAME" = "$MONITOR_LABEL" ]; then
  echo "  Monitor summary element name is incorrect. Expected '$MONITOR_LABEL' but was '$MONITOR_SUMMARY_NAME'."
  exit 1
else
  echo "  Monitor summary element name is correct"
fi

#echo "---------- MONITOR_SUMMARY_NAME"
#echo "$MONITOR_SUMMARY_NAME"
#echo "----------"

echo "" && \
echo "Checking monitor summary topic" && \

MONITOR_SUMMARY_TOPIC=$(jq -r '.dashboards[0].dashboard[0].topic' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$MONITOR_SUMMARY_TOPIC" = "$MONITOR_CALIBRATED_TOPIC" ]; then
  echo "  Monitor summary topic is incorrect. It is '$MONITOR_SUMMARY_TOPIC' but '$MONITOR_CALIBRATED_TOPIC' was expected."
  exit 1
else
  echo "  Monitor summary topic is correct"
fi

#echo "---------- MONITOR_SUMMARY_TOPIC"
#echo "$MONITOR_SUMMARY_TOPIC"
#echo "----------"

echo "" && \
echo "Checking linear MQTT monitor tab" && \

MONITOR_TAB=$(jq -r '.tabs[1]' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$MONITOR_TAB" = "null" ]; then
  echo "  Monitor tab found"
else
  echo "  Monitor tab not found"
  exit 1
fi

#echo "---------- MONITOR_TAB"
#echo "$MONITOR_TAB"
#echo "----------"

echo "" && \
echo "Checking linear MQTT monitor tab name" && \

MONITOR_TAB_NAME=$(jq -r '.tabs[1].name' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ "$MONITOR_TAB_NAME" = "null" ]; then
 echo "   Invalid monitor name name. Expected '$MONITOR_LABEL' but was '$MONITOR_TAB_NAME'."
 exit 1
else
  echo "  Monitor tab name is correct"
fi

#echo "---------- MONITOR_TAB_NAME"
#echo "$MONITOR_TAB_NAME"
#echo "----------"

echo "" && \
echo "Checking linear MQTT monitor dashboard" && \

MONITOR_DASHBOARD=$(jq -r '.dashboards[1]' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$MONITOR_DASHBOARD" = "null" ]; then
  echo "  Monitor dashboard found"
else
  echo "  Monitor dashboard not found."
  exit 1
fi

#echo "---------- MONITOR_DASHBOARD"
#echo "$MONITOR_DASHBOARD"
#echo "----------"

echo "" && \
echo "Checking linear MQTT monitor dashboard id" && \

MONITOR_DASHBOARD_ID=$(jq -r '.dashboards[1].id' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ "$MONITOR_DASHBOARD_ID" = "2" ]; then
  echo "  Monitor dashboard ID is valid."
else
  echo "  Monitor dashboard ID is invalid. Expected '2' but was '$MONITOR_DASHBOARD_ID'."
  exit 1
fi

#echo "---------- MONITOR_DASHBOARD_ID"
#echo "$MONITOR_DASHBOARD_ID"
#echo "----------"

echo "" && \
echo "Checking linear MQTT monitor dashboard calibrated entry" && \

MONITOR_DASHBOARD_CALIBRATED_ENTRY=$(jq -r '.dashboards[1].dashboard[0]' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ ! "$MONITOR_DASHBOARD_CALIBRATED_ENTRY" = "null" ]; then
  echo "  Monitor dashboard calibrated entry found"
else
  echo "  Monitor dashboard calibrated entry not found."
  exit 1
fi

#echo "---------- MONITOR_DASHBOARD_CALIBRATED_ENTRY_NAME"
#echo "$MONITOR_DASHBOARD_CALIBRATED_ENTRY_NAME"
#echo "----------"

echo "" && \
echo "Checking linear MQTT monitor dashboard calibrated entry topic" && \

MONITOR_DASHBOARD_CALIBRATED_ENTRY_TOPIC=$(jq -r '.dashboards[1].dashboard[0].topic' $NEW_LINEAR_MQTT_SETTINGS_FILE) && \
if [ "$MONITOR_DASHBOARD_CALIBRATED_ENTRY_TOPIC" = "$MONITOR_CALIBRATED_TOPIC" ]; then
  echo "  Monitor dashboard calibrated entry topic is correct"
else
  echo "  Monitor dashboard calibrated entry topic is incorrect. Expected '$MONITOR_CALIBRATED_TOPIC' but was '$MONITOR_DASHBOARD_CALIBRATED_ENTRY_TOPIC'."
  exit 1
fi

echo "Monitor test complete"