DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

TYPE=$(cat "devices/$DEVICE_NAME/type.txt")

# Soil moisture monitor
if [ "$TYPE" = "monitor/SoilMoistureSensorCalibratedSerial" ]; then
  sh view-garden-monitor-device-mqtt.sh $DEVICE_NAME
fi
if [ "$TYPE" = "monitor/SoilMoistureSensorCalibratedSerialESP" ]; then
  sh view-garden-monitor-device-mqtt.sh $DEVICE_NAME
fi

# Irrigator
if [ "$TYPE" = "irrigator/SoilMoistureSensorCalibratedPump" ]; then
  sh view-garden-irrigator-device-mqtt.sh $DEVICE_NAME
fi
if [ "$TYPE" = "irrigator/SoilMoistureSensorCalibratedPumpESP" ]; then
  sh view-garden-irrigator-device-mqtt.sh $DEVICE_NAME
fi

# Illuminator
if [ "$TYPE" = "illuminator/LightPRSensorCalibratedLight" ]; then
  sh view-garden-illuminator-device-mqtt.sh $DEVICE_NAME
fi

# Ventilator
if [ "$TYPE" = "ventilator/TemperatureHumidityDHTSensorFan" ]; then
  sh view-garden-ventilator-device-mqtt.sh $DEVICE_NAME
fi
