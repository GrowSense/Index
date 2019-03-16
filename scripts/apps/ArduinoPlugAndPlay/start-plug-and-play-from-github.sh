
INIT_SCRIPT_FILE_URL="https://raw.githubusercontent.com/GreenSense/Index/master/scripts/apps/ArduinoPlugAndPlay/init.sh"
wget --no-cache -O init.sh $INIT_SCRIPT_FILE_URL

sh init.sh || exit 1

mono ArduinoPlugAndPlay/lib/net40/ArduinoPlugAndPlay.exe $1 $2 $3 $4 $5 $6 $7 $8 $9
