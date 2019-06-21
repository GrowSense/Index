echo "Stopping GreenSense supervisor service..."

bash "wait-for-unlock.sh" # In quotes to avoid color coding issue in editor

sh systemctl.sh stop greensense-supervisor.service || echo "Failed to stop supervisor service"
