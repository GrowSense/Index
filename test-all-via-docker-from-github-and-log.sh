#!/bin/bash

TEST_SCRIPT_URL="https://raw.githubusercontent.com/GreenSense/Index/master/test-project-via-docker-from-github-and-log.sh"

curl $TEST_SCRIPT_URL | bash -s "sketches/monitor/SoilMoistureSensorCalibratedSerial" 2>&1
curl $TEST_SCRIPT_URL | bash -s "sketches/irrigator/SoilMoistureSensorCalibratedPump" 2>&1
