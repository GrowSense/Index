
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

echo "WiFi network name: $WIFI_NAME"

echo $WIFI_NAME > wifi-name.security
echo $WIFI_PASSWORD > wifi-password.security

echo "Done"

