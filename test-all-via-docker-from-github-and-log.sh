# SoilMoistureSensorCalibratedSerial
TIMESTAMP=$(date +"%Y_%m_%d_%I_%M_%p")
SOIL_MOISTURE_SENSOR_CALIBRATED_SERIAL_PATH="/home/$USER/workspace/GreenSense/Index/sketches/monitor/SoilMoistureSensorCalibratedSerial"
LOGS_PATH="$SOIL_MOISTURE_SENSOR_CALIBRATED_SERIAL_PATH/logs"
LOG_PATH="$LOGS_PATH/$TIMESTAMP.log"
mkdir -p $LOGS_PATH
echo "Logging to: $LOG_PATH"
curl -s https://raw.githubusercontent.com/GreenSense/SoilMoistureSensorCalibratedSerial/master/test-via-docker-from-github.sh | bash > $LOG_PATH
