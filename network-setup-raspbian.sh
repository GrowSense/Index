echo "Setting up network (on raspbian)..."

NETWORK_CONNECTION_TYPE=$(cat network-connection-type.txt)

echo "  Network connection type: $NETWORK_CONNECTION_TYPE"

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

WPA_SUPPLICANT_FILE="/etc/wpa_supplicant/wpa_supplicant.conf"

if [ "$NETWORK_CONNECTION_TYPE" == "WiFi" ]; then
  echo "  Is WiFi connection..."

# TODO: Remove if not needed
#  $SUDO ifconfig wlan0 down
#  $SUDO ifconfig wlan0 up

  COUNTRY_CODE=$(cat country-code.txt)
  WIFI_NAME=$(cat wifi-network-name.security)
  WIFI_PASS=$(cat wifi-network-password.security)

  echo "  Country code: $COUNTRY_CODE"
  echo "  Name: $WIFI_NAME"
  echo "  Pass: $WIFI_PASS"

  echo "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev" > "$WPA_SUPPLICANT_FILE"
  echo "update_config=1" >> "$WPA_SUPPLICANT_FILE"
  echo "country=$COUNTRY_CODE" >> "$WPA_SUPPLICANT_FILE"
  echo "network={" >> "$WPA_SUPPLICANT_FILE"
  echo "    ssid=\"$WIFI_NAME\"" >> "$WPA_SUPPLICANT_FILE"
  echo "    psk=\"$WIFI_PASS\"" >> "$WPA_SUPPLICANT_FILE"
  echo "}" >> "$WPA_SUPPLICANT_FILE"


  IFCONFIG_RESULT="$(ifconfig)"

  if [[ "$IFCONFIG_RESULT" = *"ap0"* ]]; then
    echo "  Hotspot is running. Stopping..."
    hotspot modpar self autostart no
    hotspot stop
  fi

# TODO: Remove if not needed
#  echo "  Terminating WiFi..."
#  $SUDO wpa_cli -p /var/run/wpa_supplicant/ -i wlan0 terminate || echo "  Skipping terminate WiFi"

#  echo "  Sleeping for 3 seconds..."
#  sleep 3

#  echo "  Loading wpa_supplicant.conf file and connecting to WiFi..."
#  $SUDO wpa_supplicant -B -i wlan0 -c $WPA_SUPPLICANT_FILE -f /etc/wpa_supplicant/wpa_supplicant.log

  sleep 5

  echo "  Restarting wpa_supplicant..."
  $SUDO systemctl restart wpa_supplicant

  echo "  Restarting dhcpd..."
  $SUDO systemctl restart dhcpcd

# TODO: Remove if not needed
#    echo ""
#    echo "  Reloading wpa_supplicant.conf file..."

#    RECONFIGURE_RESULT="$($SUDO wpa_cli -i wlan0 reconfigure)"

#    if [[ "$RECONFIGURE_RESULT" = "" ]]; then#
#      echo "  Starting wpa_supplicant..."
#
#    if [[ "$RECONFIGURE_RESULT" = *"OK"* ]]; then
#      echo "  wpa_supplicant.conf file reloaded successfully."
#    else
#      echo "  Failed to reload wpa_supplicant.conf file."
#      echo ""
#      echo "  Ouput from command: wpa_cli -i wlan0 reconfigure..."
#      echo ""
#      echo "----- Start "
#      echo "$RECONFIGURE_RESULT"
#      echo "----- End "
#      echo ""
#      echo "Failed to connect"
#      exit 1
#    fi

  echo ""
  echo "  Waiting 10 seconds for WiFi to connect..."
  sleep 10

  echo "  Checking WiFi connection..."
  #RESULT=$(iwconfig 2>&1 | grep wlan0) # TODO: Remove if not needed
  RESULT=$(ifconfig wlan0 | grep inet | wc -l)

  if [[ "$RESULT" = "0" ]]; then
    echo "  WiFi connection failed"
  else
    echo "  WiFi connected"
  fi

elif [ "$NETWORK_CONNECTION_TYPE" == "WiFiHotSpot" ]; then
  echo "  Is WiFi hotspot connection..."

  COUNTRY_CODE=$(cat country-code.txt)
  HOTSPOT_NAME=$(cat wifi-hotspot-name.security)
  HOTSPOT_PASS=$(cat wifi-hotspot-password.security)

  echo "  Country code: $COUNTRY_CODE"
  echo "  Name: $HOTSPOT_NAME"
  echo "  Pass: $HOTSPOT_PASS"

  #hotspot setup
  hotspot modpar self autostart yes
  hotspot modpar hostapd ssid $HOTSPOT_NAME
  hotspot modpar hostapd wpa_passphrase $HOTSPOT_PASS
  hotspot modpar hostapd country_code $COUNTRY_CODE
  hotspot modpar crda REGDOMAIN $COUNTRY_CODE
  #hotspot try
  hotspot start

  echo "  WiFi hotspot connected"
elif [ "$NETWORK_CONNECTION_TYPE" == "Ethernet" ]; then
  echo "  Is ethernet..."

  IFCONFIG_RESULT="$(ifconfig)"

  if [[ "$IFCONFIG_RESULT" = *"ap0"* ]]; then
    echo "  Hotspot is running. Stopping..."
    hotspot modpar self autostart no
    hotspot stop
  fi

  ifconfig wlan0 down
  ifconfig eth0 up

  ETHERNET_RESULT=$(ethtool eth0 | grep "Link")

  if [[ "$ETHERNET_RESULT" = *"Link detected: yes" ]]; then
    echo "  Ethernet connected"
  else
    echo "  Ethernet connection failed"
  fi
else
  echo "  Network connection type not supported..."
  echo "    Type: $NETWORK_CONNECTION_TYPE"
fi

echo "Finished reconnecting to network (on raspbian)."
