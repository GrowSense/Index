#!/bin/bash

echo ""
echo "Starting test of entire GreenSense project suite"
echo ""

PROJECT_TEST_SCRIPT_URL="https://raw.githubusercontent.com/GreenSense/Index/master/test-project-via-docker-from-github-and-log.sh"

curl -H 'Cache-Control: no-cache' -s $PROJECT_TEST_SCRIPT_URL | bash -s 1 "sketches/monitor/SoilMoistureSensorCalibratedSerial" dev
curl -H 'Cache-Control: no-cache' -s $PROJECT_TEST_SCRIPT_URL | bash -s 2 "sketches/irrigator/SoilMoistureSensorCalibratedPump" dev

#curl -H 'Cache-Control: no-cache' -s $PROJECT_TEST_SCRIPT_URL | bash -s 1 "sketches/monitor/SoilMoistureSensorCalibratedSerial" master
#curl -H 'Cache-Control: no-cache' -s $PROJECT_TEST_SCRIPT_URL | bash -s 2 "sketches/irrigator/SoilMoistureSensorCalibratedPump" master


echo ""
echo "Finished tests!"
echo ""
