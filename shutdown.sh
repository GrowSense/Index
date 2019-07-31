SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

bash mqtt-publish.sh "/garden/StatusMessage" "Shutting down" || echo "MQTT publish failed."

bash "wait-for-unlock.sh" || exit 1
$SUDO shutdown now
