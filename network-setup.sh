echo "Reconnecting to network..."

LOOP_NUMBER=$1

if [ ! "$LOOP_NUMBER" ]; then
  LOOP_NUMBER=1
fi

echo "  Loop number: $LOOP_NUMBER"

#MAX_LOOPS=3
MAX_LOOPS=10

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

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

if [ "$IS_RASPBIAN" == "1" ]; then
  echo "  Operating system is raspbian. Reconnecting..."

  CONNECT_RESULT=$($SUDO bash network-setup-raspbian.sh)
else
  echo "  Operating system is not raspbian. Skipping reconnect because it's not supported."
fi

echo ""
echo "  Connect result..."
echo ""
echo "----- Start Connect Result "
echo "$CONNECT_RESULT"
echo "----- End Connect Result"
echo ""

#if [[ ! $(echo $PING_MQTT_RESULT) =~ "64 bytes from" ]]; then
if [[ "$CONNECT_RESULT" = *"connected"* ]]; then
  echo "  Connection successful."
else
  if [ "$LOOP_NUMBER" -lt "$MAX_LOOPS" ]; then
#    echo "  Failed to ping MQTT broker. Reconnect likely failed..."
    echo "  Connection failed."

    echo "  Sleeping for 15 seconds then retrying..."
#    sleep 5
    sleep 15

    echo "  Retrying..."
    bash network-setup.sh $(($LOOP_NUMBER+1))
  else
    echo "  Can't connect to network. Reverting back to previous settings..."

    cp network-connection-type-previous.txt network-connection-type.txt
    echo "    Connection type: $(cat network-connection-type.txt)"

    CONNECTION_TYPE=$(cat network-connection-type.txt)

    if [ "$CONNECTION_TYPE" = "WiFi" ]; then
      cp wifi-network-name-previous.security wifi-network-name.security
      echo "    WiFi name: $(cat wifi-network-name.security)"
      cp wifi-network-password-previous.security wifi-network-password.security
    fi

    bash network-setup.sh
  fi
fi

