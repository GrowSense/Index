echo "Reconnecting to network (on raspbian)..."

NETWORK_CONNECTION_TYPE=$(cat network-connection-type.txt)

echo "  Network connection type: $NETWORK_CONNECTION_TYPE"

if [ "$NETWORK_CONNECTION_TYPE" == "WiFi" ]; then
  echo "  Is WiFi connection..."

  WIFI_NAME=$(cat wifi-network-name.security)
  WIFI_PASS=$(cat wifi-network-password.security)

  echo "  Name: $WIFI_NAME"
  echo "  Pass: $WIFI_PASS"

  WPA_SUPPLICANT_FILE="/etc/wpa_supplicant/wpa_supplicant.conf"

  WPA_SUPPLICANT_CONTENT="network={\nssid="$WIFI_NAME"\npsk=\“$WIFI_PASS\”\n}"

  hotspot stop

  echo "$WPA_SUPPLICANT_CONTENT" > "$WPA_SUPPLICANT_FILE"

elif [ "$NETWORK_CONNECTION_TYPE" == "WiFiHotSpot" ]; then
  echo "  Is WiFi hotspot connection..."

  HOTSPOT_NAME=$(cat wifi-hotspot-name.security)
  HOTSPOT_PASS=$(cat wifi-hotspot-password.security)

  echo "  Name: $HOTSPOT_NAME"
  echo "  Pass: $HOTSPOT_PASS"

  hotspot setup
  hotspot modpar hostapd ssid $HOTSPOT_NAME 
  hotspot modpar hostapd wpa_passphrase $HOTSPOT_PASS
  hotspot try
  hotspot start
else
  echo "  Is ethernet..."

  hotspot stop
fi

echo "Finished reconnecting to network (on raspbian)."