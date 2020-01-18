echo "Starting GrowSense WWW Upgrading service..."

bash systemctl.sh enable growsense-www-upgrading.service
bash systemctl.sh start growsense-www-upgrading.service

echo "Finished starting GrowSense WWW Upgrading service."