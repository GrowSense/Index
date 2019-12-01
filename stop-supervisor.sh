echo "Stopping GrowSense supervisor service..."

bash "wait-for-unlock.sh" # In quotes to avoid color coding issue in editor

if [ -f /lib/systemd/system/growsense-supervisor.service ]; then
sh systemctl.sh stop growsense-supervisor.service || echo "Failed to stop supervisor service"
fi
