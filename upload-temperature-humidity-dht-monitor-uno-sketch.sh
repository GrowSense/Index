
# Example:
# bash upload-temperature-humidity-dht-monitor-uno-sketch.sh "NewTHMonitor" ttyUSB0

DIR=$PWD

DEVICE_NAME=$1
SERIAL_PORT=$2

DEFAULT_DEVICE_NAME="NewTHMonitor"

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="$DEFAULT_DEVICE_NAME"
fi

if [ ! $SERIAL_PORT ]; then
  SERIAL_PORT="ttyUSB0"
fi

# If the serial port was provided as an argument but not the device name then use it
[[ $(echo $DEVICE_NAME) =~ "tty" ]] && SERIAL_PORT="$DEVICE_NAME" && DEVICE_NAME="$DEFAULT_DEVICE_NAME"

bash upload-device-sketch-arduino.sh "uno" "monitor" "TemperatureHumidityDHTSensorSerial" $DEVICE_NAME $SERIAL_PORT
