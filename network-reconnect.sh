echo "Reconnecting to network..."

if [ -f "/etc/os-release" ]; then
  RASPBIAN_INFO="$(cat /etc/os-release | grep -w Raspbian)"
else
  RASPBIAN_INFO=""
fi

if [ "$RASPBIAN_INFO" != "" ]; then
  IS_RASPBIAN=1
else
  IS_RASPBIAN=0
fi

if [ "$IS_RASPBIAN" == "1" ]; then
  echo "  Operating system is raspbian. Reconnecting..."

  bash network-reconnect-raspbian.sh
else
  echo "  Operating system is not raspbian. Skipping reconnect because it's not supported."
fi

MQTT_HOST=$(cat mqtt-host.security)

echo "  Pinging MQTT server..."
echo "    MQTT Host: $MQTT_HOST"
PING_MQTT_RESULT="$(ping -c 1 $MQTT_HOST)"

echo ""
echo "  Ping result..."
echo "${PING_MQTT_RESULT}"

if [[ ! $(echo $PING_MQTT_RESULT) =~ "64 bytes from" ]]; then
  echo "  Failed to ping MQTT broker. Reconnect likely failed..."

  echo "  Sleeping for 15 seconds then retrying..."
  sleep 15

  echo "  Retrying..."
  bash network-reconnect.sh
fi

#elif [[ $(echo $PING_MQTT_RESULT) =~ "unknown host" ]]; then
#  echo "  MQTT broker/server is down or inaccessible..."

#  bash send-email.sh "Error: MQTT server $MQTT_HOST is down or inaccessible (from $HOST)" "Failed to ping MQTT server...\n\nMQTT Host: $MQTT_HOST\nGarden Computer: $HOST\n\nPing result...\n\n${PING_MQTT_RESULT}"

#  bash create-alert-file.sh "MQTT server $MQTT_HOST is down or inaccessible (from $HOST)"

#  exit 1
#fi

echo "Finished reconnecting to network."
