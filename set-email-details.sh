#!/bin/bash

echo ""
echo "Setting email details..."
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

echo "  SMTP server: $SMTP_SERVER"
echo "  Admin email: $ADMIN_EMAIL"

echo $SMTP_SERVER > "smtp-server.security"
echo $ADMIN_EMAIL > "admin-email.security"

bash "set-email-details-for-mqtt-bridge.sh" "$SMTP_SERVER" "$ADMIN_EMAIL" && \
bash "set-email-details-for-1602-ui.sh" "$SMTP_SERVER" "$ADMIN_EMAIL" && \
bash "set-email-details-for-arduino-plug-and-play.sh" "$SMTP_SERVER" "$ADMIN_EMAIL" && \

echo "Finished setting email details."
