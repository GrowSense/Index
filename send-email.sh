echo "Sending email to administrator..."

SUBJECT="$1"
MESSAGE="$2"

if [ ! "$SUBJECT" ]; then
  echo "Please provide a subject as an argument."
  exit 1
fi

if [ ! "$MESSAGE" ]; then
  echo "Please provide a message as an argument."
  exit 1
fi

[[ -f "smtp-server.security" ]] && SMTP_SERVER=$(cat smtp-server.security)
[[ -f "admin-email.security" ]] && EMAIL_ADDRESS=$(cat admin-email.security)
[[ -f "smtp-username.security" ]] && SMTP_USERNAME=$(cat smtp-username.security)
[[ -f "smtp-password.security" ]] && SMTP_PASSWORD=$(cat smtp-password.security)
[[ -f "smtp-port.security" ]] && SMTP_PORT=$(cat smtp-port.security)

EMAIL_DETAILS_ARE_SET=1

[[ ! "$SMTP_SERVER" ]] && EMAIL_DETAILS_ARE_SET=0
[[ "$SMTP_SERVER" = "na" ]] && EMAIL_DETAILS_ARE_SET=0
[[ "$SMTP_SERVER" = "mail.example.com" ]] && EMAIL_DETAILS_ARE_SET=0
[[ ! "$EMAIL_ADDRESS" ]] && EMAIL_DETAILS_ARE_SET=0
[[ "$EMAIL_ADDRESS" = "na" ]] && EMAIL_DETAILS_ARE_SET=0
[[ "$EMAIL_ADDRESS" = "user@example.com" ]] && EMAIL_DETAILS_ARE_SET=0

EMAIL_CREDENTIALS_ARE_SET=1

[[ ! "$SMTP_USERNAME" ]] && EMAIL_CREDENTIALS_ARE_SET=0
[[ "$SMTP_USERNAME" = "na" ]] && EMAIL_CREDENTIALS_ARE_SET=0
[[ "$SMTP_USERNAME" = "user" ]] && EMAIL_CREDENTIALS_ARE_SET=0
[[ ! "$SMTP_PASSWORD" ]] && EMAIL_CREDENTIALS_ARE_SET=0
[[ "$SMTP_PASSWORD" = "na" ]] && EMAIL_CREDENTIALS_ARE_SET=0
[[ "$SMTP_PASSWORD" = "pass" ]] && EMAIL_CREDENTIALS_ARE_SET=0

HOST=$(cat /etc/hostname)

FOOTER="----------------------------------------\nEmail sent by GrowSense system on $HOST."

if [ "$EMAIL_DETAILS_ARE_SET" = "1" ]; then

  echo "  SMTP Server: $SMTP_SERVER"
  echo "  Admin Email: $EMAIL_ADDRESS"
  echo "  SMTP Port: $SMTP_PORT"
  echo ""

  if [ "$EMAIL_CREDENTIALS_ARE_SET" = "1" ]; then
    echo "  SMTP server credentials have been set. Using authentication..."
    echo "  SMTP Username: $SMTP_USERNAME"
    echo "  SMTP Password: [hidden]"
    echo ""
  fi

  echo "  Subject: $SUBJECT"
  echo "  Message:"
  echo "---"
  echo "$MESSAGE"
  echo "---"
  echo ""

  if [ "$EMAIL_CREDENTIALS_ARE_SET" = "1" ]; then
    CREDENTIALS_ARGUMENTS=" -xu $SMTP_USERNAME -xp $SMTP_PASSWORD"
  fi

  sendemail -f $EMAIL_ADDRESS -t $EMAIL_ADDRESS -u $SUBJECT -m "$MESSAGE\n\n\n$FOOTER" -s $SMTP_SERVER:$SMTP_PORT -o tls=auto $CREDENTIALS_ARGUMENTS

  echo "Finished sending email to administrator."
else
  echo "Email details not set. Skipping."
fi
