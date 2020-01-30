echo "Reconnecting to network (on raspbian)..."

NETWORK_CONNECTION_TYPE=$(cat network-connection-type.txt)

echo "  Network connection type: $NETWORK_CONNECTION_TYPE"

WPA_SUPPLICANT_FILE="/etc/wpa_supplicant/wpa_supplicant.conf"

if [ "$NETWORK_CONNECTION_TYPE" == "WiFi" ]; then
  echo "  Is WiFi connection..."

  WIFI_NAME=$(cat wifi-network-name.security)
  WIFI_PASS=$(cat wifi-network-password.security)

  echo "  Name: $WIFI_NAME"
  echo "  Pass: $WIFI_PASS"

  hotspot stop

  echo "ctrl_interface=/var/run/wpa_supplicant GROUP=netdev" > "$WPA_SUPPLICANT_FILE"
  echo "update_config=1" >> "$WPA_SUPPLICANT_FILE"
  echo "network={" >> "$WPA_SUPPLICANT_FILE"
  echo "ssid=\"$WIFI_NAME\"" >> "$WPA_SUPPLICANT_FILE"
  echo "psk=\"$WIFI_PASS\"" >> "$WPA_SUPPLICANT_FILE"
  echo "}" >> "$WPA_SUPPLICANT_FILE"

  ifconfig wlan0 up

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

#  echo "ctrl_interface=/var/run/wpa_supplicant GROUP=netdev" > "$WPA_SUPPLICANT_FILE"
#  echo "update_config=1" >> "$WPA_SUPPLICANT_FILE"
#  echo "network={" >> "$WPA_SUPPLICANT_FILE"
#  echo "ssid=\"disabled\"" >> "$WPA_SUPPLICANT_FILE"
#  echo "psk=\"disabled\"" >> "$WPA_SUPPLICANT_FILE"
#  echo "}" >> "$WPA_SUPPLICANT_FILE"

  ifconfig wlan0 down
fi

echo "Finished reconnecting to network (on raspbian)."