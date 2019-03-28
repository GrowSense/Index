echo "-----"
echo "Supervising GreenSense system..."

sh supervise-devices.sh || (echo "Supervise garden devices failed." && exit 1)

sh upgrade.sh || (echo "Upgrade failed." && exit 1)

echo "-----"
