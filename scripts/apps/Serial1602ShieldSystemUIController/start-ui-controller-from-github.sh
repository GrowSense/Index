BRANCH=$1

if [ ! $BRANCH ]; then
  BRANCH="master"
fi

echo "Branch: $BRANCH"

INIT_SCRIPT_FILE_URL="https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts/apps/Serial1602ShieldSystemUIController/init.sh"
curl --connect-timeout 3 -o init.sh -f $INIT_SCRIPT_FILE_URL || echo "Failed to download init.sh file"

sh init.sh || exit 1

mono Serial1602ShieldSystemUIController/lib/net40/Serial1602ShieldSystemUIControllerConsole.exe $1 $2 $3 $4 $5 $6 $7 $8 $9
