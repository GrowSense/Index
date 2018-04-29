echo "Building entire index"

DIR=$PWD

cd sketches/monitor/SoilMoistureSensorCalibratedSerial
sh build-all.sh
cd $DIR

cd sketches/monitor/SoilMoistureSensorCalibratedSerialESP
sh build-all.sh
cd $DIR

cd sketches/irrigator/SoilMoistureSensorCalibratedPump
sh build-all.sh
cd $DIR

cd sketches/irrigator/SoilMoistureSensorCalibratedPumpESP
sh build-all.sh
cd $DIR