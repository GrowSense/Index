echo "Supervising network..."

NETWORK_CONNECTION_TYPE=$(cat network-connection-type.txt)

echo "  Connection type: $NETWORK_CONNECTION_TYPE"

if [ "$NETWORK_CONNECTION_TYPE" == "WiFi" ]; then

  RESULT=$(ifconfig wlan0 | grep inet | wc -l)

  if [[ "$RESULT" = "0" ]]; then
    echo "  WiFi is not connected. Running network setup..."
    bash systemctl.sh start growsense-network-setup
  else
    echo "  WiFi connected"
  fi

elif [ "$NETWORK_CONNECTION_TYPE" == "WiFiHotSpot" ]; then

  IFCONFIG_RESULT="$(ifconfig)"

  if [[ "$IFCONFIG_RESULT" = *"ap0"* ]]; then
    echo "  WiFi hotspot is running"
  else
    echo "  WiFi hotspot is not active. Running network setup..."
    bash systemctl.sh start growsense-network-setup
  fi

elif [ "$NETWORK_CONNECTION_TYPE" == "Ethernet" ]; then

  ETHERNET_RESULT=$(ethtool eth0 | grep "Link")

  if [[ "$ETHERNET_RESULT" = *"Link detected: yes" ]]; then
    echo "  Ethernet connected"
  else
    echo "  Ethernet not connected. Running network setup..."
    bash systemctl.sh start growsense-network-setup
  fi

fi

echo "Finished supervising network"
