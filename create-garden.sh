echo ""
echo "Creating GreenSense garden..."
echo ""

bash create-mqtt-service.sh && \

sh expose-ui-config-via-http.sh

echo ""
echo "Setup complete"
echo ""
