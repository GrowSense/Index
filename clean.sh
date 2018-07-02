DIR=$PWD

echo ""
echo "Cleaning project"
echo ""

sh remove-garden-devices.sh

TMP_DIR="$PWD.tmp";

echo $TMP_DIR

if [ -d "$TMP_DIR" ]; then
  sudo rm "$TMP_DIR/" -r
fi

cd mobile/linearmqtt/
sh reset.sh

cd $DIR

echo "Done"
