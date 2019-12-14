echo "Updating GrowSense plug and play..."

BRANCH=$1
INSTALL_DIR=$2

EXAMPLE_COMMAND="Example:\n..sh [Branch] [InstallDir]"

if [ ! $BRANCH ]; then
  BRANCH="master"
fi

if [ "$INSTALL_DIR" = "?" ]; then
    INSTALL_DIR="/usr/local/GrowSense/Index"
fi
if [ ! "$INSTALL_DIR" ]; then
    INSTALL_DIR="/usr/local/GrowSense/Index"
fi

echo ""
echo "  Branch: $BRANCH"
echo "  Install dir: $INSTALL_DIR"

INDEX_DIR="$INSTALL_DIR"
GREENSENSE_DIR="$(dirname $INSTALL_DIR)"
BASE_DIR="$(dirname $GREENSENSE_DIR)"

INDEX_DIR=$INSTALL_DIR

echo "  Checking for GrowSense index dir..."
if [ ! -d $INDEX_DIR ]; then
  echo "    GrowSense Index doesn't appear to be installed at:"
  echo "       $INDEX_DIR"
  echo "    Use the install-plug-and-play-from-web-sh script instead."
  exit 1
fi

echo ""
echo "  Moving to GrowSense index dir..."
echo "    $INDEX_DIR"
cd $INDEX_DIR || exit 1

echo ""
echo "  Upgrading system..."
bash upgrade-system.sh || exit 1

echo ""
echo "Finished updating GrowSense plug and play!"
