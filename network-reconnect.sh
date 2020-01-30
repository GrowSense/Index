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

echo "Finished reconnecting to network."