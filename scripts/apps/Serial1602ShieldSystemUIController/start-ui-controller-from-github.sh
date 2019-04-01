BRANCH=$1

if [ ! $BRANCH ]; then
  BRANCH="master"
fi

echo "Branch: $BRANCH"

INIT_SCRIPT_FILE_URL="https://raw.githubusercontent.com/GreenSense/Index/$BRANCH/scripts/apps/Serial1602ShieldSystemUIController/init.sh"
wget --no-cache -O init.sh $INIT_SCRIPT_FILE_URL

sh init.sh || exit 1

mono Serial1602ShieldSystemUIController/lib/net40/Serial1602ShieldSystemUIController.exe $1 $2 $3 $4 $5 $6 $7 $8 $9
