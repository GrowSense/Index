echo ""
echo "Creating GrowSense SystemManager WWW Upgrading service..."
echo ""

SERVICE_FILE_PATH="$PWD/www/upgrading/svc/growsense-www-upgrading.service"

echo ""
echo "  Installing service file..."
bash install-service.sh $SERVICE_FILE_PATH 0 || exit 1

echo ""
echo "Finished creating GrowSense SystemManager WWW service"
