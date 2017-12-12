#!/bin/bash

echo ""
echo "Starting test of entire GreenSense project suite"
echo ""

TEST_SCRIPT_URL="https://raw.githubusercontent.com/GreenSense/Index/master/test-project-via-docker-from-github-and-log.sh"

curl $TEST_SCRIPT_URL | bash -s "sketches/monitor/SoilMoistureSensorCalibratedSerial"
#curl $TEST_SCRIPT_URL | bash -s "sketches/irrigator/SoilMoistureSensorCalibratedPump"

echo ""
echo "Finished tests!"
echo ""
