echo "Stopping GrowSense mesh manager service..."

if [ -f /lib/systemd/system/growsense-mesh-manager.service ]; then
  sh systemctl.sh stop growsense-mesh-manager.service || echo "Failed to stop mesh manager service"
fi
