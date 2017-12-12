#!/bin/bash

echo ""
echo "Starting test of entire GreenSense project suite"
echo ""

TEST_SCRIPT_URL="https://raw.githubusercontent.com/GreenSense/Index/master/test-project-via-docker-from-github-and-log.sh"

#curl -H 'Cache-Control: no-cache' -s $TEST_SCRIPT_URL | bash -s 1 "sketches/monitor/SoilMoistureSensorCalibratedSerial"
curl -H 'Cache-Control: no-cache' -s $TEST_SCRIPT_URL | bash -s 2 "sketches/irrigator/SoilMoistureSensorCalibratedPump"

echo ""
echo "Finished tests!"
echo ""
