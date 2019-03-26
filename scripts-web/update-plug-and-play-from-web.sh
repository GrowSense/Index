echo "Updating GreenSense plug and play..."

BRANCH=$1

EXAMPLE_COMMAND="Example:\n..sh [branch]"

if [ ! $BRANCH ]; then
  BRANCH="master"
fi

echo "Branch: $BRANCH"

PNP_INSTALL_DIR="/usr/local/ArduinoPlugAndPlay"

echo "Branch name: $BRANCH"

echo "Checking for ArduinoPlugAndPlay install dir..."
if [ ! -d $PNP_INSTALL_DIR ]; then
  echo "ArduinoPlugAndPlay doesn't appear to be installed at:"
  echo "  $PNP_INSTALL_DIR"
  echo "Use the install-plug-and-play-from-web-sh script instead."
  exit 1
fi

INDEX_DIR="$PNP_INSTALL_DIR/workspace/GreenSense/Index"

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
sh update-all.sh $BRANCH || (echo "Failed to update GreenSense index. Script: update.sh" && exit 1)

echo "Reinitializing index..."
sh init-all.sh $BRANCH || (echo "Failed to update GreenSense index. Script: update.sh" && exit 1)

echo "Updating ArduinoPlugAndPlay (by downloading update-from-web.sh file)..."
wget -v --no-cache -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/$BRANCH/scripts-web/update-from-web.sh | bash -s - $BRANCH || (echo "Failed to update ArduinoPlugAndPlay. Script: update-from-web.sh" && exit 1)


echo "Finished reinstalling GreenSense plug and play!"
