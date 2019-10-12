#!/bin/bash

echo ""
echo "Starting test of entire GrowSense project suite"
echo ""

BRANCH="dev"

PROJECT_TEST_SCRIPT_URL="https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/test-project-via-docker-from-github-and-log.sh"

curl -H 'Cache-Control: no-cache' -s $PROJECT_TEST_SCRIPT_URL | bash -s 1 "sketches/monitor/SoilMoistureSensorCalibratedSerial" $BRANCH
curl -H 'Cache-Control: no-cache' -s $PROJECT_TEST_SCRIPT_URL | bash -s 2 "sketches/irrigator/SoilMoistureSensorCalibratedPump" $BRANCH

BRANCH="master"

PROJECT_TEST_SCRIPT_URL="https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/test-project-via-docker-from-github-and-log.sh"

curl -H 'Cache-Control: no-cache' -s $PROJECT_TEST_SCRIPT_URL | bash -s 1 "sketches/monitor/SoilMoistureSensorCalibratedSerial" $BRANCH
curl -H 'Cache-Control: no-cache' -s $PROJECT_TEST_SCRIPT_URL | bash -s 2 "sketches/irrigator/SoilMoistureSensorCalibratedPump" $BRANCH


echo ""
echo "Finished tests!"
echo ""
