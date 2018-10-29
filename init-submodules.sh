echo "Initializing GreenSense index submodules"

DIR=$PWD

git submodule update --init --recursive && \

echo "" && \
echo "Initializing GreenSense monitor (SoilMoistureSensorCalibratedSerial) submodule" && \

cd sketches/monitor/SoilMoistureSensorCalibratedSerial/ && \
sh init.sh && \
cd $DIR && \

echo "" && \
echo "Initializing GreenSense WiFi/ESP monitor (SoilMoistureSensorCalibratedSerialESP) submodule" && \

cd sketches/monitor/SoilMoistureSensorCalibratedSerialESP/ && \
sh init.sh && \
cd $DIR && \

echo "" && \
echo "Initializing GreenSense irrigator (SoilMoistureSensorCalibratedPump) submodule" && \

cd sketches/irrigator/SoilMoistureSensorCalibratedPump/ && \
sh init.sh && \
cd $DIR && \

echo "" && \
echo "Initializing GreenSense WiFi/ESP irrigator (SoilMoistureSensorCalibratedPumpESP) submodule" && \

cd sketches/irrigator/SoilMoistureSensorCalibratedPumpESP/ && \
sh init.sh && \
cd $DIR && \

echo "Finished initializing submodules"