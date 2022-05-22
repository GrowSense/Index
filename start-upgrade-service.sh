echo "Starting GrowSense upgrade service..."

# TODO: Remove if not needed. Switching over to using new installer for upgrades
#sh systemctl.sh start growsense-upgrade.service

bash gs.sh upgrade
