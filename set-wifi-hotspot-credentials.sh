
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

echo "Setting WiFi hotspot credentials..."
echo "  WiFi hotspot name: $WIFI_NAME"

echo $WIFI_NAME > wifi-hotspot-name.security
echo $WIFI_PASSWORD > wifi-hotspot-password.security

echo "Finished setting WiFi hotspot credentials."

