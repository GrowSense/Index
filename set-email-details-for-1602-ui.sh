#!/bin/bash

echo ""
echo "Setting email details 1602 LCD shield UI controller..."
echo ""

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

if [ -f "is-mock-ui-controller.txt" ]; then
  IS_MOCK_UI_CONTROLLER=1
  echo "Is mock setup"
fi

echo "SMTP server: $SMTP_SERVER"
echo "Admin email: $ADMIN_EMAIL"

echo ""
echo "Setting UI controller config file:"

CONFIG_FILE="scripts/apps/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIController/lib/net40/Serial1602ShieldSystemUIController.exe.config"
echo "  $CONFIG_FILE"

if [ ! -f "$CONFIG_FILE.bak" ]; then
  echo "Backing up the original config file"
  cp $CONFIG_FILE $CONFIG_FILE.bak
fi

echo "Restoring blank starter config file"
cp -f $CONFIG_FILE.bak $CONFIG_FILE

echo "Inserting values"
xmlstarlet ed -L -u '/configuration/appSettings/add[@key="SmtpServer"]/@value' -v "$SMTP_SERVER" $CONFIG_FILE
xmlstarlet ed -L -u '/configuration/appSettings/add[@key="EmailAddress"]/@value' -v "$ADMIN_EMAIL" $CONFIG_FILE

CONFIG_FILE2="scripts/apps/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIController.exe.config"

echo "Keeping a backup of the new config file"
echo "$CONFIG_FILE2"
cp -f $CONFIG_FILE $CONFIG_FILE2

echo "Installing config file to"

if [ $IS_MOCK_UI_CONTROLLER = 0 ]; then
  echo "Real UI Controller"
  INSTALL_DIR="/usr/local/Serial1602ShieldSystemUIController"
  sudo mkdir -p $INSTALL_DIR
  sudo cp -f $CONFIG_FILE2 $INSTALL_DIR/Serial1602ShieldSystemUIController.exe.config
else
  echo "Mock UI Controller"
  INSTALL_DIR="mock/Serial1602ShieldSystemUIController"
  mkdir -p $INSTALL_DIR
  cp -f $CONFIG_FILE2 $INSTALL_DIR/Serial1602ShieldSystemUIController.exe.config
fi

echo "$INSTALL_DIR/Serial1602ShieldSystemUIController.exe.config"

echo ""
echo "Finished setting email details for 1602 LCD UI controller"
