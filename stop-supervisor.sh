echo "Stopping GreenSense supervisor service..."

sh systemctl.sh stop greensense-supervisor.service || echo "Failed to stop supervisor service"
