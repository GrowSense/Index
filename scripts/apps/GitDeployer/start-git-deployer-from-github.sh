
INIT_SCRIPT_FILE_URL="https://raw.githubusercontent.com/GreenSense/Index/master/scripts/apps/GitDeployer/init.sh"
wget -O - $INIT_SCRIPT_FILE_URL | sh -s || exit 1

mono GitDeployer/lib/net40/GitDeployer.exe $1 $2 $3 $4 $5
