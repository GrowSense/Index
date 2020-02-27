echo "Stopping GrowSense supervisor service..."

if [ -f /lib/systemd/system/growsense-supervisor.service ]; then
  sh systemctl.sh stop growsense-supervisor.service || echo "Failed to stop supervisor service"
fi
