echo ""
echo "Listing garden device services"
echo ""

DIR=$PWD


echo ""
echo "MQTT Bridge Services"
echo ""

cd scripts/apps/BridgeArduinoSerialToMqttSplitCsv/svc/
for filename in *.service; do
  [ -f "$filename" ] || break
  echo "Removing device: $filename" && \
  echo "" && \
  sudo systemctl stop "$filename" && \
  sudo systemctl disable "$filename" && \
  rm $filename
done
cd $DIR

echo ""
echo "Updater Services"
echo ""

cd scripts/apps/GitDeployer/svc/
for filename in *.service; do
  [ -f "$filename" ] || break
  echo "Removing device: $filename" && \
  echo "" && \
  sudo systemctl stop "$filename" && \
  sudo systemctl disable "$filename" && \
  rm $filename && \
  echo ""
done
cd $DIR

cd mobile/linearmqtt && \
sh reset.sh && \
cd $DIR

echo "Finished removing device services"
