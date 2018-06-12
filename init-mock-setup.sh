echo "Configuring this workspace as a mock setup"

MOCK_FLAG_FILE="is-mock-setup.txt"

echo "Flag file: $PWD/$MOCK_FLAG_FILE"

echo "true" > $MOCK_FLAG_FILE

sh init-mock-systemctl.sh
sh init-mock-docker.sh
sh init-mock-hardware.sh

echo "Done"
