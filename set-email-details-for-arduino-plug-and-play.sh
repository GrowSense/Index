#!/bin/bash

echo ""
echo "Setting email details for Arduino Plug and Play..."

SMTP_SERVER=$1
ADMIN_EMAIL=$2


if [ ! "$SMTP_SERVER" ]; then
  echo "Please provide an SMTP server as an argument."
  exit 1
fi

if [ ! "$ADMIN_EMAIL" ]; then
  echo "Please provide an admin email address as an argument."
  exit 1
fi

IS_MOCK_MQTT_BRIDGE=0
if [ -f "is-mock-mqtt-bridge.txt" ]; then
  IS_MOCK_MQTT_BRIDGE=1
  echo "  Is mock setup"
fi

echo "  SMTP server: $SMTP_SERVER"
echo "  Admin email: $ADMIN_EMAIL"


CONFIG_FILE_NAME="ArduinoPlugAndPlay.exe.config"
APP_NAME="ArduinoPlugAndPlay"

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

if [ -f "$INSTALL_PACKAGE_CONFIG_FILE" ]; then
  $SUDO bash inject-xml-value.sh $INSTALL_PACKAGE_CONFIG_FILE "/configuration/appSettings/add[@key=\"SmtpServer\"]/@value" "$SMTP_SERVER" || exit 1
  $SUDO bash inject-xml-value.sh $INSTALL_PACKAGE_CONFIG_FILE "/configuration/appSettings/add[@key=\"EmailAddress\"]/@value" "$ADMIN_EMAIL" || exit 1
  $SUDO cp -f $INSTALL_PACKAGE_CONFIG_FILE $INSTALL_CONFIG_FILE || exit 1
else
  echo "  Arduino plug and play config file not found. Skipping..."
fi

echo ""
echo "Finished setting email details for Arduino Plug and Play"
