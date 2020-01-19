SERVICE_RESULT="$(bash systemctl.sh status growsense-www.service)"

HOST=$(cat /etc/hostname)

if [[ $(echo $SERVICE_RESULT) =~ "Reason: No such file or directory" ]]; then
  echo "  WWW service doesn't exist."
  bash send-email.sh "Error: WWW service hasn't been installed on $HOST." "The WWW service hasn't been installed on $HOST. Installing service...\n\nResult from 'bash systemctl.sh status growsense-www.service' command:\n\n$SERVICE_RESULT"

  bash mqtt-publish.sh "garden/StatusMessage" "WWW offline" -r

  bash create-alert-file.sh "WWW service hasn't been installed on $HOST. Installing service..."

  bash create-www-service.sh
elif [[ $(echo $SERVICE_RESULT) =~ "Active: inactive" ]] ||  [[ $(echo $SERVICE_RESULT) =~ "Active: dead" ]] ||  [[ $(echo $SERVICE_RESULT) =~ "Active: failed" ]]; then
  echo "  WWW service isn't active. Restarting..."
  bash send-email.sh "Error: WWW service isn't active on $HOST. Restarting service..." "The website service isn't running on $HOST.  Restarting service...\n\nResult from 'bash systemctl.sh status growsense-www.service' command:\n\n$SERVICE_RESULT"

  bash mqtt-publish.sh "garden/StatusMessage" "WWW offline" -r

  bash create-alert-file.sh "WWW service isn't active on $HOST. Restarting service..."

  bash restart-www-service.sh
else
  echo "  WWW service is active."
fi
