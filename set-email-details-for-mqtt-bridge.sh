#!/bin/bash

echo ""
echo "Setting email details for MQTT bridge..."

SMTP_SERVER=$1
ADMIN_EMAIL=$2
SMTP_USERNAME=$3
SMTP_PASSWORD=$4
SMTP_PORT=$5

if [ ! "$SMTP_SERVER" ]; then
  echo "Please provide an SMTP server as an argument."
  exit 1
fi

if [ ! "$ADMIN_EMAIL" ]; then
  echo "Please provide an admin email address as an argument."
  exit 1
fi

if [ ! "$SMTP_USERNAME" ]; then
  SMTP_USERNAME="na"
fi

if [ ! "$SMTP_PASSWORD" ]; then
  SMTP_PASSWORD="na"
fi

if [ ! "$SMTP_PORT" ]; then
  SMTP_PORT="25"
fi

IS_MOCK_MQTT_BRIDGE=0
if [ -f "is-mock-mqtt-bridge.txt" ]; then
  IS_MOCK_MQTT_BRIDGE=1
  echo "  Is mock setup"
fi

echo "  SMTP server: $SMTP_SERVER"
echo "  Admin email: $ADMIN_EMAIL"
echo "  SMTP username: $SMTP_USERNAME"
echo "  SMTP password: [hidden]"
echo "  SMTP port: $SMTP_PORT"

CONFIG_FILE_NAME="BridgeArduinoSerialToMqttSplitCsv.exe.config"
APP_NAME="BridgeArduinoSerialToMqttSplitCsv"

INDEX_APP_PACKAGE_CONFIG_FILE="scripts/apps/$APP_NAME/$APP_NAME/lib/net40/$CONFIG_FILE_NAME"
#INDEX_APP_CONFIG_FILE="scripts/apps/BridgeArduinoSerialToMqttSplitCsv/$CONFIG_FILE_NAME"

echo ""
echo "  Setting email values in mqtt bridge config file:"
echo "    $INDEX_APP_PACKAGE_CONFIG_FILE"

#if [ ! -f "$INDEX_APP_PACKAGE_CONFIG_FILE.bak" ]; then
#  echo ""
#  echo "  Backing up the original config file"
#  echo "    From"
#  echo "      $INDEX_APP_PACKAGE_CONFIG_FILE"
#  echo "    To"
#  echo "      $INDEX_APP_PACKAGE_CONFIG_FILE.bak"
#  cp $INDEX_APP_PACKAGE_CONFIG_FILE $INDEX_APP_PACKAGE_CONFIG_FILE.bak
#fi

echo "  Inserting email values into config file..."
bash inject-xml-value.sh $INDEX_APP_PACKAGE_CONFIG_FILE "/configuration/appSettings/add[@key=\"SmtpServer\"]/@value" "$SMTP_SERVER" || exit 1
bash inject-xml-value.sh $INDEX_APP_PACKAGE_CONFIG_FILE "/configuration/appSettings/add[@key=\"EmailAddress\"]/@value" "$ADMIN_EMAIL" || exit 1
bash inject-xml-value.sh $INDEX_APP_PACKAGE_CONFIG_FILE "/configuration/appSettings/add[@key=\"SmtpUsername\"]/@value" "$SMTP_USERNAME" || exit 1
bash inject-xml-value.sh $INDEX_APP_PACKAGE_CONFIG_FILE "/configuration/appSettings/add[@key=\"SmtpPassword\"]/@value" "$SMTP_PASSWORD" || exit 1
bash inject-xml-value.sh $INDEX_APP_PACKAGE_CONFIG_FILE "/configuration/appSettings/add[@key=\"SmtpPort\"]/@value" "$SMTP_PORT" || exit 1

#echo ""
#echo "  Checking email values were inserted into config file..."
#INDEX_APP_PACKAGE_CONFIG_FILE_CONTENT=$(cat $INDEX_APP_PACKAGE_CONFIG_FILE)

#echo "${INDEX_APP_PACKAGE_CONFIG_FILE_CONTENT}"

#[[ ! $(echo $INDEX_APP_PACKAGE_CONFIG_FILE_CONTENT) =~ "$SMTP_SERVER" ]] && echo "The SMTP server wasn't inserted into the config file" && exit 1
#[[ ! $(echo $INDEX_APP_PACKAGE_CONFIG_FILE_CONTENT) =~ "$ADMIN_EMAIL" ]] && echo "The admin email wasn't inserted into the config file" && exit 1


#echo ""
#echo "  Keeping a backup of the new config file..."
#echo "    From"
#echo "      $INDEX_APP_PACKAGE_CONFIG_FILE"
#echo "    To"
#echo "      $INDEX_APP_CONFIG_FILE"
#cp -f $INDEX_APP_PACKAGE_CONFIG_FILE $INDEX_APP_CONFIG_FILE || exit 1


echo "  Installing config file to..."

# sudo is used for a real installation, but not used for a mock installation
SUDO=""

if [ $IS_MOCK_MQTT_BRIDGE = 0 ]; then
  echo "    Real MQTT bridge"
  INSTALL_BASE="/usr/local"
  SUDO="sudo"
else
  echo "    Mock MQTT bridge"
  INSTALL_BASE="mock"
  SUDO=""
fi

INSTALL_DIR="$INSTALL_BASE/$APP_NAME"
INSTALL_CONFIG_FILE="$INSTALL_DIR/$CONFIG_FILE_NAME"
INSTALL_PACKAGE_DIR="$INSTALL_DIR/$APP_NAME/lib/net40"
INSTALL_PACKAGE_CONFIG_FILE="$INSTALL_PACKAGE_DIR/$CONFIG_FILE_NAME"

echo "    Directory:"
echo "      $INSTALL_DIR"
echo "    File:"
echo "      $INSTALL_CONFIG_FILE"

if [ ! -d $INSTALL_PACKAGE_DIR ]; then
  echo ""
  echo "  Creating install package directory..."
  $SUDO mkdir -p $INSTALL_PACKAGE_DIR || exit 1
fi

echo ""
echo "  Inserting details into install package directory..."
#echo "    From:"
#echo "      $INSTALL_CONFIG_FILE"
#echo "    To:"
#echo "      $INSTALL_PACKAGE_CONFIG_FILE"

$SUDO bash inject-xml-value.sh $INSTALL_PACKAGE_CONFIG_FILE "/configuration/appSettings/add[@key=\"SmtpServer\"]/@value" "$SMTP_SERVER" || exit 1
$SUDO bash inject-xml-value.sh $INSTALL_PACKAGE_CONFIG_FILE "/configuration/appSettings/add[@key=\"EmailAddress\"]/@value" "$ADMIN_EMAIL" || exit 1
$SUDO bash inject-xml-value.sh $INSTALL_PACKAGE_CONFIG_FILE "/configuration/appSettings/add[@key=\"SmtpUsername\"]/@value" "$SMTP_USERNAME" || exit 1
$SUDO bash inject-xml-value.sh $INSTALL_PACKAGE_CONFIG_FILE "/configuration/appSettings/add[@key=\"SmtpPassword\"]/@value" "$SMTP_PASSWORD" || exit 1
$SUDO bash inject-xml-value.sh $INSTALL_PACKAGE_CONFIG_FILE "/configuration/appSettings/add[@key=\"SmtpPort\"]/@value" "$SMTP_PORT" || exit 1
#$SUDO cp -f $INSTALL_CONFIG_FILE $INSTALL_PACKAGE_CONFIG_FILE || exit 1

echo ""
echo "Finished setting email details for MQTT bridge"
