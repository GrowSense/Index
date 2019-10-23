echo ""
echo "Creating GrowSense SystemManager WWW service..."
echo ""

SERVICE_FILE_PATH="$PWD/www/SystemManagerWWW/svc/growsense-www.service"

echo ""
echo "  Installing service file..."
bash install-service.sh $SERVICE_FILE_PATH || exit 1

echo ""
echo "Finished creating GrowSense SystemManager WWW service"
