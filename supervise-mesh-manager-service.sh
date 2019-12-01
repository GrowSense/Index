SERVICE_RESULT="$(bash systemctl.sh status growsense-mesh-manager.service)"

HOST=$(cat /etc/hostname)

if [[ $(echo $SERVICE_RESULT) =~ "No such file or directory" ]]; then
  echo "Mesh manager service isn't active"
  bash send-email.sh "Mesh manager service hasn't been installed on $HOST." "The mesh manager service hasn't been installed on $HOST.  Installing service...\n\nResult from 'bash systemctl.sh status growsense-mesh-manager.service' command:\n\n$SERVICE_RESULT"

  bash mqtt-publish.sh "garden/StatusMessage" "Mesh manager offline" -r
  
  bash create-alert-file.sh "Mesh manager service hasn't been installed on $HOST. Installing service..."

  bash create-mesh-manager-service.sh
elif [[ $(echo $SERVICE_RESULT) =~ "inactive" ]] ||  [[ $(echo $SERVICE_RESULT) =~ "dead" ]] ||  [[ $(echo $SERVICE_RESULT) =~ "failed" ]]; then
  echo "Mesh manager service isn't active"
  bash send-email.sh "Mesh manager service isn't active on $HOST. Restarting service..." "The mesh manager service isn't running on $HOST.  Restarting service...\n\nResult from 'bash systemctl.sh status growsense-mesh-manager.service' command:\n\n$SERVICE_RESULT"

  bash mqtt-publish.sh "garden/StatusMessage" "Mesh manager offline" -r

  bash create-alert-file.sh "Mesh manager service isn't active on $HOST. Restarting service..."

  bash restart-mesh-manager-service.sh
else
  echo "Mesh manager service is active"
fi
