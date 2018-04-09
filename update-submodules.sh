echo "Updating submodules by checking out the master branch and pulling from origin/master..."

DIR=$PWD

echo "Updating SoilMoistureSensorCalibratedSerial"

cd sketches/monitor/SoilMoistureSensorCalibratedSerial && \
git checkout master && \
git pull origin master || exit 1

cd $DIR

echo "Updating SoilMoistureSensorCalibratedPump"

cd sketches/irrigator/SoilMoistureSensorCalibratedPump && \
git checkout master && \
git pull origin master || exit 1

cd $DIR

git commit -am "Updated submodules"

echo "Finished updating submodules"