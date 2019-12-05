echo "Removing mosquitto docker container..."

docker rm mosquitto -f || echo "Failed to remove container. It may not exist."

echo "Finished removing mosquitto docker container"