
# Example:
# bash upload-irrigator-sketch-esp.sh "myWiFiIrrigator" ttyUSB0

DEVICE_NAME=$1
SERIAL_PORT=$2

DEFAULT_DEVICE_NAME="NewWiFiIrrigator"

if [ ! $SERIAL_PORT ]; then
  SERIAL_PORT="ttyUSB0"
fi

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="$DEFAULT_DEVICE_NAME"
fi

# If the serial port was provided as an argument but not the device name then use it
[[ $(echo $DEVICE_NAME) =~ "tty" ]] && SERIAL_PORT="$DEVICE_NAME" && DEVICE_NAME="$DEFAULT_DEVICE_NAME"

bash upload-device-sketch-esp.sh "irrigator" "SoilMoistureSensorCalibratedPumpESP" $DEVICE_NAME $DEVICE_PORT
