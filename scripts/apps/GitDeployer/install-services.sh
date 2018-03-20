echo "Installing services"
FILES=svc/*.service
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
  sudo systemctl daemon-reload
  sudo systemctl enable $filename
  sudo systemctl restart $filename

  echo "Finished installing service"
  echo ""
done

echo "Finished installing services"
