DIR=$PWD

echo ""
echo "Cleaning project"
echo ""

sh remove-garden-devices.sh

TMP_DIR="$PWD/../Index.tmp";

if [ -d "$TMP_DIR" ]; then
  sudo rm "$TMP_DIR/" -r
fi

cd mobile/linearmqtt/
sh reset.sh

cd $DIR

echo "Done"
