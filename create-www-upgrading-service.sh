echo ""
echo "Creating GrowSense SystemManager WWW upgrading service..."
echo ""

SERVICE_FILE_PATH="$PWD/www/upgrading/svc/growsense-www-upgrading.service"

echo ""
echo "  Installing service file..."
bash install-service.sh $SERVICE_FILE_PATH 0 || exit 1

echo ""
echo "  Disabling service file (it will be enabled when it's being launched)..."
bash systemctl.sh disable growsense-www-upgrading.service || exit 1

echo ""
echo "Finished creating GrowSense SystemManager WWW upgrading service"
