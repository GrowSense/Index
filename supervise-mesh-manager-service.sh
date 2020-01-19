SERVICE_RESULT="$(bash systemctl.sh status growsense-mesh-manager.service)"

HOST=$(cat /etc/hostname)

if [[ $(echo $SERVICE_RESULT) =~ "Reason: No such file or directory" ]]; then
  echo "  Mesh manager service doesn't exist."
  bash send-email.sh "Error: Mesh manager service hasn't been installed on $HOST." "The mesh manager service hasn't been installed on $HOST.  Installing service...\n\nResult from 'bash systemctl.sh status growsense-mesh-manager.service' command:\n\n$SERVICE_RESULT"

  bash mqtt-publish.sh "garden/StatusMessage" "Mesh manager offline" -r

  bash create-alert-file.sh "Mesh manager service hasn't been installed on $HOST. Installing service..."

  bash create-mesh-manager-service.sh
elif [[ $(echo $SERVICE_RESULT) =~ "Active: inactive" ]] ||  [[ $(echo $SERVICE_RESULT) =~ "Active: dead" ]] ||  [[ $(echo $SERVICE_RESULT) =~ "Active: failed" ]]; then
  echo "  Mesh manager service isn't active. Restarting..."
  bash send-email.sh "Error: Mesh manager service isn't active on $HOST. Restarting service..." "The mesh manager service isn't running on $HOST.  Restarting service...\n\nResult from 'bash systemctl.sh status growsense-mesh-manager.service' command:\n\n$SERVICE_RESULT"

  bash mqtt-publish.sh "garden/StatusMessage" "Mesh manager offline" -r

  bash create-alert-file.sh "Mesh manager service isn't active on $HOST. Restarting service..."

  bash restart-mesh-manager-service.sh
else
  echo "Mesh manager service is active"
fi
