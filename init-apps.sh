DIR=$PWD

BRANCH=$1

echo "ARG1: $1"

if [ ! "$BRANCH" ]; then
  echo "  Branch argument not provided. Using git branch..."
  BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
fi
if [ ! "$BRANCH" ]; then
  echo "  Branch argument not provided. Using default lts branch..."
  BRANCH="lts"
fi

echo "[init-apps.sh] Initializing apps..."
echo "[init-apps.sh] "
echo "[init-apps.sh]   Branch: $BRANCH"


echo ""
echo "[init-apps.sh] Initializing MQTT bridge utility"

cd scripts/apps/BridgeArduinoSerialToMqttSplitCsv/ && \
bash init.sh $BRANCH || exit 1
cd $DIR

echo "[init-apps.sh] "
echo "[init-apps.sh] Initializing UI controller"

cd scripts/apps/Serial1602ShieldSystemUIController/ && \
bash init.sh || exit 1
cd $DIR

echo "Done"
