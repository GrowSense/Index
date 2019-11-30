echo "Stopping GrowSense mesh manager service..."

sh systemctl.sh stop growsense-mesh-manager.service || echo "Failed to stop mesh manager service"
