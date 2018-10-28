echo ""
echo "Removing garden device services"
echo ""

DIR=$PWD

SYSTEMCTL_SCRIPT="systemctl.sh"

echo ""
echo "Device Info"
echo ""

if [ -d "devices" ]; then
  rm devices/* -r
fi

echo ""
echo "Mobile UI Settings"
echo ""

cd mobile/linearmqtt && \
sh reset.sh && \
cd $DIR


echo ""
echo "MQTT Bridge Services"
echo ""

for filename in scripts/apps/BridgeArduinoSerialToMqttSplitCsv/svc/*.service; do
  [ -f "$filename" ] || break
  shortname=$(basename $filename)
  echo "Removing service: $filename" && \
  echo "" && \
  rm -v $filename || exit 1
done

echo ""
echo "Updater Services"
echo ""

for filename in scripts/apps/GitDeployer/svc/*.service; do
  [ -f "$filename" ] || break
  shortname=$(basename $filename)
  echo "Removing service: $filename" && \
  echo "" && \
  rm -v $filename || exit 1
done

echo ""
echo "Installed services"
echo ""

for filename in /lib/systemd/system/greensense-*.service; do
  [ -f "$filename" ] || break
  shortname=$(basename $filename)
  echo "Removing service: $shortname" && \
  echo "" && \
  sudo sh $SYSTEMCTL_SCRIPT stop "$shortname" && \
  sudo sh $SYSTEMCTL_SCRIPT disable "$shortname" && \
  echo "" && \
  sudo rm -v $filename || exit 1
done

echo "Finished removing garden device services"
