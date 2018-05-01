
echo "----------"
echo "Testing create garden scripts"
echo "----------"

sh create-garden.sh && \

echo "----------" && \
echo "Checking results" && \
echo "----------" && \

SERVICE_FILE="/lib/systemd/system/greensense-mosquitto-docker.service" && \

if [ ! -f "$SERVICE_FILE" ]; then
    echo "Mosquitto docker service file not found at:" && \
    echo "$SERVICE_FILE" && \
    exit 1
else
    echo "Mosquitto docker service file found:" && \
    echo "$SERVICE_FILE"
fi

echo "----------" && \
echo "Cleaning up" && \
echo "----------" && \

sh disable-garden.sh