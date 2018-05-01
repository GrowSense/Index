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
  shortname=$(basename $filename)
  echo "Removing service: $filename" && \
  echo "" && \
  #sudo sh $SYSTEMCTL_SCRIPT stop "$filename" && \
  #sudo sh $SYSTEMCTL_SCRIPT disable "$filename" && \
  echo "" && \
  rm -v $filename || exit 1
  #rm -v /lib/systemd/system/$shortname || exit 1
done

echo ""
echo "Updater Services"
echo ""

for filename in scripts/apps/GitDeployer/svc/*.service; do
  [ -f "$filename" ] || break
  shortname=$(basename $filename)
  echo "Removing service: $filename" && \
  echo "" && \
  #sudo sh $SYSTEMCTL_SCRIPT stop "$filename" && \
  #sudo sh $SYSTEMCTL_SCRIPT disable "$filename" && \
  echo "" && \
  rm -v $filename || exit 1
  #rm -v /lib/systemd/system/$shortname || exit 1
done

for filename in /lib/systemd/system/greensense-*.service; do
  [ -f "$filename" ] || break
  shortname=$(basename $filename)
  echo "Removing service: $filename" && \
  echo "" && \
  sudo sh $SYSTEMCTL_SCRIPT stop "$filename" && \
  sudo sh $SYSTEMCTL_SCRIPT disable "$filename" && \
  echo "" && \
  sudo rm -v $filename || exit 1
done

cd mobile/linearmqtt && \
sh reset.sh && \
cd $DIR

echo "Finished removing device services"
