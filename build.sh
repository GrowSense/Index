echo "Building entire index"

INDEX_DIR=$PWD

cd sketches/monitor/SoilMoistureSensorCalibratedSerial && \
sh build-all.sh && \
cd $INDEX_DIR && \

cd sketches/monitor/SoilMoistureSensorCalibratedSerialESP && \
sh build-all.sh && \
cd $INDEX_DIR && \

cd sketches/irrigator/SoilMoistureSensorCalibratedPump && \
sh build-all.sh && \
cd $INDEX_DIR && \

cd sketches/irrigator/SoilMoistureSensorCalibratedPumpESP && \
sh build-all.sh && \
cd $INDEX_DIR && \

echo "Build index complete"
