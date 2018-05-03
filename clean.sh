DIR=$PWD

echo ""
echo "Cleaning project"
echo ""

sh remove-garden-devices.sh

cd mobile/linearmqtt
sh reset.sh
cd $DIR

echo "Done"
