#!/bin/bash

echo ""
echo "Setting email details 1602 LCD shield UI controller..."
echo ""

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

IS_MOCK_UI_CONTROLLER=0
if [ -f "is-mock-ui-controller.txt" ]; then
  IS_MOCK_UI_CONTROLLER=1
  echo "Is mock setup"
fi

echo "  SMTP server: $SMTP_SERVER"
echo "  Admin email: $ADMIN_EMAIL"
echo "  SMTP username: $SMTP_USERNAME"
echo "  SMTP password: [hidden]"
echo "  SMTP port: $SMTP_PORT"

echo ""
echo "Setting UI controller config file:"

CONFIG_FILE_NAME="Serial1602ShieldSystemUIControllerConsole.exe.config"
APP_NAME="Serial1602ShieldSystemUIController"

INDEX_APP_PACKAGE_CONFIG_FILE="scripts/apps/$APP_NAME/$APP_NAME/lib/net40/$CONFIG_FILE_NAME"

echo ""
echo "  Setting email values in serial UI controller config file:"
echo "    $INDEX_APP_PACKAGE_CONFIG_FILE"
#if [ ! -f "$CONFIG_FILE.bak" ]; then
#  echo "Backing up the original config file"
#  cp $CONFIG_FILE $CONFIG_FILE.bak
#fi

#echo "Restoring blank starter config file"
#cp -f $CONFIG_FILE.bak $CONFIG_FILE

echo "  Inserting email values into config file..."
bash inject-xml-value.sh "$INDEX_APP_PACKAGE_CONFIG_FILE" "/configuration/appSettings/add[@key=\"SmtpServer\"]/@value" "$SMTP_SERVER" || exit 1
bash inject-xml-value.sh "$INDEX_APP_PACKAGE_CONFIG_FILE" "/configuration/appSettings/add[@key=\"EmailAddress\"]/@value" "$ADMIN_EMAIL" || exit 1
bash inject-xml-value.sh "$INDEX_APP_PACKAGE_CONFIG_FILE" "/configuration/appSettings/add[@key=\"SmtpUsername\"]/@value" "$SMTP_USERNAME" || exit 1
bash inject-xml-value.sh "$INDEX_APP_PACKAGE_CONFIG_FILE" "/configuration/appSettings/add[@key=\"SmtpPassword\"]/@value" "$SMTP_PASSWORD" || exit 1
bash inject-xml-value.sh "$INDEX_APP_PACKAGE_CONFIG_FILE" "/configuration/appSettings/add[@key=\"SmtpPort\"]/@value" "$SMTP_PORT" || exit 1

#CONFIG_FILE2="scripts/apps/Serial1602ShieldSystemUIController/$CONFIG_FILE_NAME"

#echo "Keeping a backup of the new config file"
#echo "  $CONFIG_FILE2"
#cp -f $CONFIG_FILE $CONFIG_FILE2

echo "  Installing config file to..."

if [ $IS_MOCK_UI_CONTROLLER = 0 ]; then
  echo "    Real UI Controller"
  INSTALL_BASE="/usr/local"
  SUDO="sudo"
else
  echo "    Mock UI Controller"
  INSTALL_BASE="mock"
  SUDO=""
fi

INSTALL_DIR="$INSTALL_BASE/$APP_NAME"
INSTALL_CONFIG_FILE="$INSTALL_DIR/$CONFIG_FILE_NAME"
INSTALL_PACKAGE_DIR="$INSTALL_DIR/$APP_NAME/lib/net40"
INSTALL_PACKAGE_CONFIG_FILE="$INSTALL_PACKAGE_DIR/$CONFIG_FILE_NAME"

echo "    Install base directory:"
echo "      $INSTALL_BASE"
echo "    Install directory:"
echo "      $INSTALL_DIR"
echo "    File:"
echo "      $INSTALL_CONFIG_FILE"

if [ ! -d $INSTALL_PACKAGE_DIR ]; then
  echo ""
  echo "  Creating install package directory..."
  $SUDO mkdir -p $INSTALL_PACKAGE_DIR || exit 1
fi

#echo "  $INSTALL_DIR/$CONFIG_FILE_NAME"

$SUDO bash inject-xml-value.sh "$INSTALL_PACKAGE_CONFIG_FILE" "/configuration/appSettings/add[@key=\"SmtpServer\"]/@value" "$SMTP_SERVER" || exit 1
$SUDO bash inject-xml-value.sh "$INSTALL_PACKAGE_CONFIG_FILE" "/configuration/appSettings/add[@key=\"EmailAddress\"]/@value" "$ADMIN_EMAIL" || exit 1
$SUDO bash inject-xml-value.sh "$INSTALL_PACKAGE_CONFIG_FILE" "/configuration/appSettings/add[@key=\"SmtpUsername\"]/@value" "$SMTP_USERNAME" || exit 1
$SUDO bash inject-xml-value.sh "$INSTALL_PACKAGE_CONFIG_FILE" "/configuration/appSettings/add[@key=\"SmtpPassword\"]/@value" "$SMTP_PASSWORD" || exit 1
$SUDO bash inject-xml-value.sh "$INSTALL_PACKAGE_CONFIG_FILE" "/configuration/appSettings/add[@key=\"SmtpPort\"]/@value" "$SMTP_PORT" || exit 1

echo ""
echo "Finished setting email details for 1602 LCD UI controller"
