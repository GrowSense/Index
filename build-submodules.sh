INDEX_DIR=$PWD

echo "Building monitor" && \
cd sketches/monitor/SoilMoistureSensorCalibratedSerial && \
sh build-all.sh && \
cd $INDEX_DIR && \
echo "" && \

echo "Building monitor ESP" && \
cd sketches/monitor/SoilMoistureSensorCalibratedSerialESP && \
sh build-all.sh && \
cd $INDEX_DIR && \
echo "" && \

echo "Building irrigator" && \
cd sketches/irrigator/SoilMoistureSensorCalibratedPump && \
sh build-all.sh && \
cd $INDEX_DIR && \
echo "" && \

echo "Building irrigator ESP" && \
cd sketches/irrigator/SoilMoistureSensorCalibratedPumpESP && \
sh build-all.sh && \
cd $INDEX_DIR && \
echo "" && \

echo "Submodules were built successfully."
