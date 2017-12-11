#!/bin/bash

# The username is hard coded to work with cron. This can be commented out to auto-detect the user.
USER=j

TIMESTAMP=$(date +"%Y_%m_%d_%I_%M_%p")

# SoilMoistureSensorCalibratedSerial
SOIL_MOISTURE_SENSOR_CALIBRATED_SERIAL_PATH="/home/$USER/workspace/GreenSense/Index/sketches/monitor/SoilMoistureSensorCalibratedSerial"
SOIL_MOISTURE_SENSOR_CALIBRATED_SERIAL_LOGS_PATH="$SOIL_MOISTURE_SENSOR_CALIBRATED_SERIAL_PATH/logs"
SOIL_MOISTURE_SENSOR_CALIBRATED_SERIAL_LOG_PATH="$SOIL_MOISTURE_SENSOR_CALIBRATED_SERIAL_LOGS_PATH/$TIMESTAMP.log"
mkdir -p $SOIL_MOISTURE_SENSOR_CALIBRATED_SERIAL_LOGS_PATH
echo "Logging to: $SOIL_MOISTURE_SENSOR_CALIBRATED_SERIAL_LOG_PATH"
curl -s https://raw.githubusercontent.com/GreenSense/SoilMoistureSensorCalibratedSerial/master/test-via-docker-from-github.sh | bash > $SOIL_MOISTURE_SENSOR_CALIBRATED_SERIAL_LOG_PATH
