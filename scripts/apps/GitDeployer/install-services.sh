echo "Installing services"
FILES=svc/*.service
SYSTEMCTL_SCRIPT="../../../../systemctl.sh"
for f in $FILES
do
  filename=$(basename "$f")

  echo ""
  echo "Found service:"
  echo $filename

  echo ""

  echo "Copying to /lib/systemd/system/:"

  sudo cp -fv $f /lib/systemd/system/$filename
  sudo chmod 644 /lib/systemd/system/$filename
  sudo sh $SYSTEMCTL_SCRIPT daemon-reload
  sudo sh $SYSTEMCTL_SCRIPT enable $filename
  sudo sh $SYSTEMCTL_SCRIPT restart $filename

  echo "Finished installing service"
  echo ""
done

echo "Finished installing services"
