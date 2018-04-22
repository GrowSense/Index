DIR=$PWD

echo ""
echo "Cleaning project"
echo ""
echo "Resetting linear MQTT UI"

cd mobile/linearmqtt
sh reset.sh
cd $DIR

echo "Done"
