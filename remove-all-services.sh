echo "Removing all GrowSense services..."

for filename in /lib/systemd/system/growsense-*.service; do
  if [[ -f "$filename" ]]; then
    shortname=$(basename $filename)
    echo "Removing service: $shortname"
    echo ""

    bash systemctl.sh stop "$shortname" || echo "Failed to stop $shortname service. Skipping."
    bash systemctl.sh disable "$shortname" || echo "Failed to disable $shortname service. Skipping."
  
    if [ ! -f "is-mock-systemctl.txt" ]; then
      $SUDO rm -v $filename || echo "Failed to remove $shortname service. Skipping."
    else
      echo "[mock] $SUDO rm -v $filename"
    fi
  fi
  echo "" 
done

echo ""
echo "  Removing mosquitto docker container..."
bash remove-mqtt-service.sh

echo "Finished removing all GrowSense services."