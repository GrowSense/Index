#!/bin/bash

echo ""
echo "Setting email details..."
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

echo "  SMTP server: $SMTP_SERVER"
echo "  Admin email: $ADMIN_EMAIL"
echo "  SMTP username: $SMTP_USERNAME"
echo "  SMTP password: [hidden]"
echo "  SMTP port: $SMTP_PORT"

echo $SMTP_SERVER > "smtp-server.security"
echo $ADMIN_EMAIL > "admin-email.security"
echo $SMTP_USERNAME > "smtp-username.security"
echo $SMTP_PASSWORD > "smtp-password.security"
echo $SMTP_PORT > "smtp-port.security"

bash "set-email-details-for-mqtt-bridge.sh" "$SMTP_SERVER" "$ADMIN_EMAIL" "$SMTP_USERNAME" "$SMTP_PASSWORD" "$SMTP_PORT" && \
bash "set-email-details-for-1602-ui.sh" "$SMTP_SERVER" "$ADMIN_EMAIL" "$SMTP_USERNAME" "$SMTP_PASSWORD" "$SMTP_PORT" && \
bash "set-email-details-for-arduino-plug-and-play.sh" "$SMTP_SERVER" "$ADMIN_EMAIL" "$SMTP_USERNAME" "$SMTP_PASSWORD" "$SMTP_PORT" && \

echo "Finished setting email details."
