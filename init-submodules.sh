echo "Initializing GreenSense index submodules"

DIR=$PWD

git submodule update --init --recursive || "Submodule update failed"

echo "" && \
echo "Initializing GreenSense monitor (SoilMoistureSensorCalibratedSerial) submodule" && \

cd sketches/monitor/SoilMoistureSensorCalibratedSerial/ && \
sh init.sh || (echo "Failed to initialize SoilMoistureSensorCalibratedSerial submodule." && exit 1)
cd $DIR && \

echo "" && \
echo "Initializing GreenSense WiFi/ESP monitor (SoilMoistureSensorCalibratedSerialESP) submodule" && \

cd sketches/monitor/SoilMoistureSensorCalibratedSerialESP/ && \
sh init.sh || (echo "Failed to initialize SoilMoistureSensorCalibratedSerialESP submodule." && exit 1)
cd $DIR && \

echo "" && \
echo "Initializing GreenSense irrigator (SoilMoistureSensorCalibratedPump) submodule" && \

cd sketches/irrigator/SoilMoistureSensorCalibratedPump/ && \
sh init.sh || (echo "Failed to initialize SoilMoistureSensorCalibratedPump submodule." && exit 1)
cd $DIR && \

echo "" && \
echo "Initializing GreenSense WiFi/ESP irrigator (SoilMoistureSensorCalibratedPumpESP) submodule" && \

cd sketches/irrigator/SoilMoistureSensorCalibratedPumpESP/ && \
sh init.sh || (echo "Failed to initialize SoilMoistureSensorCalibratedPumpESP submodule." && exit 1)
cd $DIR && \

echo "" && \
echo "Initializing GreenSense ventilator (TemperatureHumidityDHTSensorFan) submodule" && \

cd sketches/ventilator/TemperatureHumidityDHTSensorFan/ && \
sh init.sh || (echo "Failed to initialize TemperatureHumidityDHTSensorFan submodule." && exit 1)
cd $DIR && \
echo "" && \

echo "Initializing GreenSense illuminator (LightPRSensorCalibratedLight) submodule" && \

cd sketches/illuminator/LightPRSensorCalibratedLight/ && \
sh init.sh || (echo "Failed to initialize LightPRSensorCalibratedLight submodule." && exit 1)
cd $DIR && \

echo "Finished initializing submodules"
