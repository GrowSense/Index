echo "Updating submodules by checking out the master branch and pulling from origin/master..."

DIR=$PWD

echo "Updating SoilMoistureSensorCalibratedSerial"

cd sketches/monitor/SoilMoistureSensorCalibratedSerial && \
sh clean.sh && \
git checkout master && \
git pull origin master || exit 1

cd $DIR

echo "Updating SoilMoistureSensorCalibratedSerialESP"

cd sketches/monitor/SoilMoistureSensorCalibratedSerialESP && \
sh clean.sh && \
git checkout master && \
git pull origin master || exit 1

cd $DIR

echo "Updating SoilMoistureSensorCalibratedPump"

cd sketches/irrigator/SoilMoistureSensorCalibratedPump && \
sh clean.sh && \
git checkout master && \
git pull origin master || exit 1

cd $DIR

echo "Updating SoilMoistureSensorCalibratedPumpESP"

cd sketches/irrigator/SoilMoistureSensorCalibratedPumpESP && \
sh clean.sh && \
git checkout master && \
git pull origin master || exit 1

cd $DIR

git commit -am "Updated submodules"

echo "Finished updating submodules"
