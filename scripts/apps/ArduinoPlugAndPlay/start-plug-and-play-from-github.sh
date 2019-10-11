
INIT_SCRIPT_FILE_URL="https://raw.githubusercontent.com/GrowSense/Index/master/scripts/apps/ArduinoPlugAndPlay/init.sh"
wget --no-cache -O init.sh $INIT_SCRIPT_FILE_URL

sh init.sh || exit 1

START_SCRIPT_FILE_URL="https://raw.githubusercontent.com/GrowSense/Index/master/scripts/apps/ArduinoPlugAndPlay/start-plug-and-play.sh"
wget --no-cache -O start-plug-and-play.sh $START_SCRIPT_FILE_URL

sh init.sh || exit 1

sh start-plug-and-play.sh $1 $2 $3 $4 $5 $6 $7 $8 $9 || exit 1
