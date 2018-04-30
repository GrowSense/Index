echo ""
echo "Removing garden device services"
echo ""

DIR=$PWD

SYSTEMCTL_SCRIPT="systemctl.sh"

echo ""
echo "MQTT Bridge Services"
echo ""

for filename in scripts/apps/BridgeArduinoSerialToMqttSplitCsv/svc/*.service; do
  [ -f "$filename" ] || break
  echo "Removing device: $filename" && \
  echo "" && \
  sudo sh $SYSTEMCTL_SCRIPT stop "$filename" && \
  sudo sh $SYSTEMCTL_SCRIPT disable "$filename" && \
  echo "" && \
  rm $filename || exit 1
done

echo ""
echo "Updater Services"
echo ""

for filename in scripts/apps/GitDeployer/svc/*.service; do
  [ -f "$filename" ] || break
  echo "Removing device: $filename" && \
  echo "" && \
  sudo sh $SYSTEMCTL_SCRIPT stop "$filename" && \
  sudo sh $SYSTEMCTL_SCRIPT disable "$filename" && \
  echo "" && \
  rm $filename || exit 1
done

cd mobile/linearmqtt && \
sh reset.sh && \
cd $DIR

echo "Finished removing device services"
