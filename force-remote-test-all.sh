#!/bin/bash

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ]
then
  DIR=$PWD

  sh force-remote-test.sh || exit 1
  echo ""
  
  echo "Monitor"
  cd sketches/monitor/SoilMoistureSensorCalibratedSerial/
  sh force-remote-test.sh || exit 1
  cd $DIR
  echo ""
  
  echo "Monitor ESP"
  cd sketches/monitor/SoilMoistureSensorCalibratedSerialESP/
  sh force-remote-test.sh || exit 1
  cd $DIR
  echo ""
  
  echo "Irrigator"
  cd sketches/irrigator/SoilMoistureSensorCalibratedPump/
  sh force-remote-test.sh || exit 1
  cd $DIR
  echo ""
  
  echo "Irrigator ESP"
  cd sketches/irrigator/SoilMoistureSensorCalibratedPump/
  sh force-remote-test.sh || exit 1
  cd $DIR
  echo ""

  echo "Tests for all projects should now have started on the test server."
else
  echo "Cannot force retest from master branch. Switch to dev branch first."
fi
