echo "Updating GreenSense plug and play..."

BRANCH=$1
INSTALL_DIR=$2

EXAMPLE_COMMAND="Example:\n..sh [Branch] [InstallDir]"

if [ ! $BRANCH ]; then
  BRANCH="master"
fi

if [ "$INSTALL_DIR" = "?" ]; then
    INSTALL_DIR="/usr/local/GreenSense/Index"
fi
if [ ! "$INSTALL_DIR" ]; then
    INSTALL_DIR="/usr/local/GreenSense/Index"
fi

echo "Branch: $BRANCH"
echo "Install dir: $INSTALL_DIR"


INDEX_DIR="$INSTALL_DIR"
GREENSENSE_DIR="$(dirname $INSTALL_DIR)"
BASE_DIR="$(dirname $GREENSENSE_DIR)"

PNP_INSTALL_DIR="$BASE_DIR/ArduinoPlugAndPlay"


echo "Checking for ArduinoPlugAndPlay install dir..."
if [ ! -d $PNP_INSTALL_DIR ]; then
  echo "ArduinoPlugAndPlay doesn't appear to be installed at:"
  echo "  $PNP_INSTALL_DIR"
  echo "Use the install-plug-and-play-from-web-sh script instead."
  exit 1
fi

INDEX_DIR=$INSTALL_DIR

echo "Checking for GreenSense index dir..."
if [ ! -d $INDEX_DIR ]; then
  echo "GreenSense Index doesn't appear to be installed at:"
  echo "  $INDEX_DIR"
  echo "Use the install-plug-and-play-from-web-sh script instead."
  exit 1
fi

echo "Moving to GreenSense index dir..."
cd $INDEX_DIR

echo "Updating index..."
sh update-all.sh $BRANCH || (echo "Failed to update GreenSense index. Script: update-all.sh" && exit 1)

echo "Reinitializing index..."
sh init-runtime.sh $BRANCH || (echo "Failed to update GreenSense index. Script: init-runtime.sh" && exit 1)

echo "Recreating UI..."
sh recreate-garden-ui.sh || (echo "Failed to recreate garden UI. Script: recreate-garden-ui.sh" && exit 1)

echo "Recreating garden services..."
sh recreate-garden-services.sh || (echo "Failed to recreate garden services. Script: recreate-garden-services.sh" && exit 1)

echo "Reloading systemctl..."
if [ ! -f "is-mock-systemctl.txt" ]; then
  systemctl daemon-reload  || (echo "Failed to reload systemctl" && exit 1)
else
  echo "[mock] systemctl daemon-reload"
fi

echo "Updating ArduinoPlugAndPlay (by downloading update-from-web.sh file)..."
wget -v --no-cache -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/$BRANCH/scripts-web/update-from-web.sh | bash -s $BRANCH $PNP_INSTALL_DIR || (echo "Failed to update ArduinoPlugAndPlay. Script: update-from-web.sh" && exit 1)


echo "Finished reinstalling GreenSense plug and play!"
