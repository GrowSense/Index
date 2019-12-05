echo "Restarting GrowSense mesh manager service..."

bash systemctl.sh restart growsense-mesh-manager.service || exit 1

echo "Finished restarting GrowSense mesh manager service"
