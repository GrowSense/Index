echo "Removing all GrowSense services..."

# TODO: This should be moved to a different script. It doesn't just remove device service scripts but removes all GrowSense services.
for filename in /lib/systemd/system/growsense-*.service; do
  [[ ! -f "$filename" ]] || break
  shortname=$(basename $filename)
  echo "Removing service: $shortname"
  echo ""
  sh $SYSTEMCTL_SCRIPT stop "$shortname" || echo "Failed to stop $shortname service. Skipping."
  sh $SYSTEMCTL_SCRIPT disable "$shortname" || echo "Failed to disable $shortname service. Skipping."
  
  if [ ! -f "is-mock-systemctl.txt" ]; then
    $SUDO rm -v $filename || echo "Failed to remove $shortname service. Skipping."
  fi
  echo "" 
done

echo "Finished removing all GrowSense services."