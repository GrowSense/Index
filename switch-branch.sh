BRANCH=$1

if [ ! $BRANCH ]; then
  BRANCH="master"
fi

DIR=$PWD

echo "Switching index to $BRANCH branch"

git checkout $BRANCH && \
git pull origin $BRANCH

cd $DIR

echo "Switching monitor to $BRANCH branch"

cd sketches/monitor/SoilMoistureSensorCalibratedSerial/
sh clean.sh && \
git checkout $BRANCH && \
git pull origin $BRANCH

cd $DIR

echo "Switching ESP monitor to $BRANCH branch"

cd sketches/monitor/SoilMoistureSensorCalibratedSerialESP/
sh clean.sh && \
git checkout $BRANCH && \
git pull origin $BRANCH

cd $DIR

echo "Switching irrigator to $BRANCH branch"

cd sketches/irrigator/SoilMoistureSensorCalibratedPump/
sh clean.sh && \
git checkout $BRANCH && \
git pull origin $BRANCH

cd $DIR

echo "Switching ESP irrigator to $BRANCH branch"

cd sketches/irrigator/SoilMoistureSensorCalibratedPumpESP/

git pull origin $BRANCH && \
git checkout $BRANCH

cd $DIR

echo "Finished switching to $BRANCH"
