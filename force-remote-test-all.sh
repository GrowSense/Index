#!/bin/bash

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ]
then
  DIR=$PWD
  
  echo "Monitor"
  cd sketches/monitor/SoilMoistureSensorCalibratedSerial/
  git checkout $BRANCH || exit 1
  sh force-remote-test.sh || exit 1
  cd $DIR
  echo ""
  
  echo "Monitor ESP"
  cd sketches/monitor/SoilMoistureSensorCalibratedSerialESP/
  git checkout $BRANCH || exit 1
  sh force-remote-test.sh || exit 1
  cd $DIR
  echo ""
  
  echo "Irrigator"
  cd sketches/irrigator/SoilMoistureSensorCalibratedPump/
  git checkout $BRANCH || exit 1
  sh force-remote-test.sh || exit 1
  cd $DIR
  echo ""
  
  echo "Irrigator ESP"
  cd sketches/irrigator/SoilMoistureSensorCalibratedPumpESP/
  git checkout $BRANCH || exit 1
  sh force-remote-test.sh || exit 1
  cd $DIR
  echo ""
  
  echo "Ventilator"
  cd sketches/ventilator/TemperatureHumidityDHTSensorFan/
  git checkout $BRANCH || exit 1
  sh force-remote-test.sh || exit 1
  cd $DIR
  echo ""
  
  
  echo "Illuminator"
  cd sketches/illuminator/LightPRSensorCalibratedLight/
  git checkout $BRANCH
  sh force-remote-test.sh || exit 1
  cd $DIR
  echo ""
  
  echo "UI"
  cd sketches/ui/Serial1602ShieldSystemUI/
  git checkout $BRANCH || exit 1
  sh force-remote-test.sh || exit 1
  cd $DIR
  echo ""
  
  sh force-remote-test.sh || exit 1
  echo ""

  echo "Tests for all projects should now have started on the test server."
else
  echo "Cannot force retest from master branch. Switch to dev branch first."
fi
