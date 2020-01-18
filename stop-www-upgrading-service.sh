echo "Stopping GrowSense WWW upgrading service..."

bash systemctl.sh stop growsense-www-upgrading.service
bash systemctl.sh disable growsense-www-upgrading.service

echo "Finished stopping GrowSense WWW upgrading service."