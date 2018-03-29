echo "Testing the GreenSense index"

NEW_SETTINGS_FILE="mobile/linearmqtt/newsettings.json"

MQTT_USERNAME="myusername"
MQTT_PASSWORD="mypassword"

MONITOR_LABEL="MyMonitor"
MONITOR_DEVICE_NAME="mymonitor"
MONITOR_PORT="ttyUSB0"
MONITOR_CALIBRATED_TOPIC="/$MONITOR_DEVICE_NAME/C"

IRRIGATOR_LABEL="MyIrrigator"
IRRIGATOR_DEVICE_NAME="myirrigator"
IRRIGATOR_PORT="ttyUSB1"
IRRIGATOR_CALIBRATED_TOPIC="/$IRRIGATOR_DEVICE_NAME/C"

echo ""
echo "Removing garden devices"
echo ""

sh remove-garden-devices.sh && \

echo "" && \
echo "Setting MQTT credentials" && \
echo "" && \


sh set-mqtt-credentials.sh $MQTT_USERNAME $MQTT_PASSWORD && \

echo "" && \
echo "Checking mosquitto userfile" && \
echo "" && \

FOUND_CREDENTIALS_STRING=$(cat scripts/docker/mosquitto/data/mosquitto.userfile)
if [ "$FOUND_CREDENTIALS_STRING" = "$MQTT_USERNAME:$MQTT_PASSWORD" ]; then
  echo "  Mosquitto userfile is valid"
else
  echo "  Mosquitto userfile is invalid. Expected '$MQTT_USERNAME:$MQTT_PASSWORD' but was '$FOUND_CREDENTIALS_STRING'"
  exit 1
fi

echo "" && \
echo "Removing existing docker services" && \
echo "" && \

sudo systemctl stop greensense-mosquitto-docker.service
sudo systemctl disable greensense-mosquitto-docker.service
docker stop mosquitto
docker rm mosquitto

echo "" && \
echo "Creating garden services" && \
echo "" && \

sh create-garden.sh && \

#
# Garden Monitor Services
#

echo "" && \
echo "Creating garden monitor services" && \
echo "" && \

sh create-garden-monitor.sh $MONITOR_LABEL $MONITOR_DEVICE_NAME $MONITOR_PORT && \

echo "" && \
echo "New settings file content:" && \
echo "--------------------" && \
jq . $NEW_SETTINGS_FILE && \
echo "--------------------" && \
echo "" && \

echo "" && \
echo "Checking linear MQTT monitor summary element" && \
echo "" && \

MONITOR_SUMMARY_ELEMENT=$(jq -r '.dashboards[0].dashboard[0]' $NEW_SETTINGS_FILE) && \
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
echo "" && \

MONITOR_SUMMARY_NAME=$(jq -r '.dashboards[0].dashboard[0].name' $NEW_SETTINGS_FILE) && \
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
echo "" && \

MONITOR_SUMMARY_TOPIC=$(jq -r '.dashboards[0].dashboard[0].topic' $NEW_SETTINGS_FILE) && \
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
echo "" && \

MONITOR_TAB=$(jq -r '.tabs[1]' $NEW_SETTINGS_FILE) && \
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
echo "" && \

MONITOR_TAB_NAME=$(jq -r '.tabs[1].name' $NEW_SETTINGS_FILE) && \
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
echo "" && \

MONITOR_DASHBOARD=$(jq -r '.dashboards[1]' $NEW_SETTINGS_FILE) && \
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
echo "" && \

MONITOR_DASHBOARD_ID=$(jq -r '.dashboards[1].id' $NEW_SETTINGS_FILE) && \
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
echo "" && \

MONITOR_DASHBOARD_CALIBRATED_ENTRY=$(jq -r '.dashboards[1].dashboard[0]' $NEW_SETTINGS_FILE) && \
if [ ! "$MONITOR_DASHBOARD_CALIBRATED_ENTRY" = "null" ]; then
  echo "  Monitor dashboard calibrated entry found"
else
  echo "  Monitor dashboard calibrated entry not found."
  exit 1
fi

#echo "---------- MONITOR_DASHBOARD_CALIBRATED_ENTRY"
#echo "$MONITOR_DASHBOARD_CALIBRATED_ENTRY"
#echo "----------"

echo "" && \
echo "Checking linear MQTT monitor dashboard calibrated entry name" && \
echo "" && \

MONITOR_DASHBOARD_CALIBRATED_ENTRY_NAME=$(jq -r '.dashboards[1].dashboard[0].name' $NEW_SETTINGS_FILE) && \
if [ "$MONITOR_DASHBOARD_CALIBRATED_ENTRY_NAME" = "$MONITOR_LABEL" ]; then
  echo "  Monitor dashboard calibrated entry name is correct"
else
  echo "  Monitor dashboard calibrated entry name is incorrect. Expected '$MONITOR_LABEL' but was '$MONITOR_DASHBOARD_CALIBRATED_ENTRY_NAME'."
  exit 1
fi

#echo "---------- MONITOR_DASHBOARD_CALIBRATED_ENTRY_NAME"
#echo "$MONITOR_DASHBOARD_CALIBRATED_ENTRY_NAME"
#echo "----------"

echo "" && \
echo "Checking linear MQTT monitor dashboard calibrated entry topic" && \
echo "" && \

MONITOR_DASHBOARD_CALIBRATED_ENTRY_TOPIC=$(jq -r '.dashboards[1].dashboard[0].topic' $NEW_SETTINGS_FILE) && \
if [ "$MONITOR_DASHBOARD_CALIBRATED_ENTRY_TOPIC" = "$MONITOR_CALIBRATED_TOPIC" ]; then
  echo "  Monitor dashboard calibrated entry topic is correct"
else
  echo "  Monitor dashboard calibrated entry topic is incorrect. Expected '$MONITOR_CALIBRATED_TOPIC' but was '$MONITOR_DASHBOARD_CALIBRATED_ENTRY_TOPIC'."
  exit 1
fi

#
# Garden Irrigator Services
#

echo "" && \
echo "Creating garden irrigator services" && \
echo "" && \

sh create-garden-irrigator.sh $IRRIGATOR_LABEL $IRRIGATOR_DEVICE_NAME $IRRIGATOR_PORT && \


echo "" && \
echo "New settings file content:" && \
echo "--------------------" && \
jq . $NEW_SETTINGS_FILE && \
echo "--------------------" && \
echo "" && \

echo "" && \
echo "Checking linear MQTT irrigator summary element" && \
echo "" && \

IRRIGATOR_SUMMARY_ELEMENT=$(jq -r '.dashboards[0].dashboard[1]' $NEW_SETTINGS_FILE) && \
if [ "$IRRIGATOR_SUMMARY_ELEMENT" = "null" ]; then
  echo "  Irrigator sumary element not found"
  exit 1
else
  echo "  Irrigator summary element found"
fi

#echo "---------- IRRIGATOR_SUMMARY_ELEMENT"
#echo "$IRRIGATOR_SUMMARY_ELEMENT"
#echo "----------"

echo "" && \
echo "Checking linear MQTT irrigator summary name" && \
echo "" && \

IRRIGATOR_SUMMARY_NAME=$(jq -r '.dashboards[0].dashboard[1].name' $NEW_SETTINGS_FILE) && \
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
echo "" && \

IRRIGATOR_SUMMARY_TOPIC=$(jq -r '.dashboards[0].dashboard[1].topic' $NEW_SETTINGS_FILE) && \
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
echo "" && \

IRRIGATOR_TAB=$(jq -r '.tabs[2]' $NEW_SETTINGS_FILE) && \
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
echo "" && \

IRRIGATOR_TAB_NAME=$(jq -r '.tabs[2].name' $NEW_SETTINGS_FILE) && \
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
echo "" && \

IRRIGATOR_DASHBOARD=$(jq -r '.dashboards[2]' $NEW_SETTINGS_FILE) && \
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
echo "Checking linear MQTT monitor dashboard id" && \
echo "" && \

MONITOR_DASHBOARD_ID=$(jq -r '.dashboards[2].id' $NEW_SETTINGS_FILE) && \
if [ "$MONITOR_DASHBOARD_ID" = "3" ]; then
  echo "  Monitor dashboard ID is valid."
else
  echo "  Monitor dashboard ID is invalid. Expected '3' but was '$MONITOR_DASHBOARD_ID'."
  exit 1
fi

#echo "---------- MONITOR_DASHBOARD_ID"
#echo "$MONITOR_DASHBOARD_ID"
#echo "----------"

echo "" && \
echo "Checking linear MQTT irrigator dashboard calibrated entry" && \
echo "" && \

IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY=$(jq -r '.dashboards[2].dashboard[0]' $NEW_SETTINGS_FILE) && \
if [ ! "$IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY" = "null" ]; then
  echo "  Irrigator dashboard calibrated entry found"
else
  echo "  Irrigator dashboard calibrated entry not found."
  exit 1
fi

#echo "---------- IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY"
#echo "$IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY"
#echo "----------"

echo "" && \
echo "Checking linear MQTT irrigator dashboard calibrated entry name" && \
echo "" && \

IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY_NAME=$(jq -r '.dashboards[2].dashboard[1].name' $NEW_SETTINGS_FILE) && \
if [ "$IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY_NAME" = "$IRRIGATOR_LABEL" ]; then
  echo "  Irrigator dashboard calibrated entry name is correct"
else
  echo "  Irrigator dashboard calibrated entry name is incorrect. Expected '$IRRIGATOR_LABEL' but was '$IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY_NAME'"
  exit 1
fi

#echo "---------- IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY_NAME"
#echo "$IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY_NAME"
#echo "----------"

echo "" && \
echo "Checking linear MQTT irrigator dashboard calibrated entry topic" && \
echo "" && \

IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY_TOPIC=$(jq -r '.dashboards[2].dashboard[1].topic' $NEW_SETTINGS_FILE) && \
if [ "$IRRIGATOR_DASHBOARD_CALIBRATED_ENTRY_TOPIC" = "$IRRIGATOR_CALIBRATED_TOPIC" ]; then
  echo "  Irrigator dashboard calibrated entry topic is correct"
else
  echo "  Irrigator dashboard calibrated entry topic is incorrect."
  exit 1
fi

sh remove-garden-device.sh $MONITOR_DEVICE_NAME && \
sh remove-garden-device.sh $IRRIGATOR_DEVICE_NAME && \

sh create-garden-monitor.sh $MONITOR_LABEL $MONITOR_DEVICE_NAME $MONITOR_PORT && \
sh create-garden-irrigator.sh $IRRIGATOR_LABEL $IRRIGATOR_DEVICE_NAME $IRRIGATOR_PORT && \

sh remove-garden-devices.sh && \

sh disable-garden.sh

echo ""
echo "Testing complete"

