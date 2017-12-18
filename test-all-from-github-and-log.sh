#!/bin/bash

echo ""
echo "Starting test of entire GreenSense project suite"
echo ""

BRANCH="dev"

PROJECT_TEST_SCRIPT_URL="https://raw.githubusercontent.com/GreenSense/Index/$BRANCH/test-project-from-github-and-log.sh"

curl -H 'Cache-Control: no-cache' -s $PROJECT_TEST_SCRIPT_URL | bash -s 1 "sketches/monitor/SoilMoistureSensorCalibratedSerial" $BRANCH
curl -H 'Cache-Control: no-cache' -s $PROJECT_TEST_SCRIPT_URL | bash -s 2 "sketches/irrigator/SoilMoistureSensorCalibratedPump" $BRANCH

BRANCH="master"

#PROJECT_TEST_SCRIPT_URL="https://raw.githubusercontent.com/GreenSense/Index/$BRANCH/test-project-from-github-and-log.sh"

#curl -H 'Cache-Control: no-cache' -s $PROJECT_TEST_SCRIPT_URL | bash -s 1 "sketches/monitor/SoilMoistureSensorCalibratedSerial" $BRANCH
#curl -H 'Cache-Control: no-cache' -s $PROJECT_TEST_SCRIPT_URL | bash -s 2 "sketches/irrigator/SoilMoistureSensorCalibratedPump" $BRANCH


echo ""
echo "Finished tests!"
echo ""
