
DIR=$PWD

WIFI_NAME=$1
WIFI_PASSWORD=$2

if [ ! $WIFI_NAME ]; then
  echo "Specify the WiFi network name as an argument."
  exit 1
fi

if [ ! $WIFI_PASSWORD ]; then
  echo "Specify the WiFi password as an argument."
  exit 1
fi

echo "Setting WiFi network credentials..."
echo "  WiFi network name: $WIFI_NAME"

if [ -f wifi-network-name.security ]; then
  cp wifi-network-name.security wifi-network-name-previous.security
fi

if [ -f wifi-network-password.security ]; then
  cp wifi-network-password.security wifi-network-password-previous.security
fi

echo $WIFI_NAME > wifi-network-name.security
echo $WIFI_PASSWORD > wifi-network-password.security

echo "Finished setting WiFi network credentials."

