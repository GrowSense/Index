BRANCH=$1

if [ ! $BRANCH ]; then
  BRANCH="master"
fi

DIR=$PWD

echo "Switching index to $BRANCH branch"

git pull origin $BRANCH && \
git checkout $BRANCH

cd $DIR

echo "Switching monitor to $BRANCH branch"

cd sketches/monitor/SoilMoistureSensorCalibratedSerial/

git pull origin $BRANCH && \
git checkout $BRANCH

cd $DIR

echo "Switching irrigator to $BRANCH branch"

cd sketches/irrigator/SoilMoistureSensorCalibratedPump/

git pull origin $BRANCH && \
git checkout $BRANCH

cd $DIR

echo "Finished switching to $BRANCH"
