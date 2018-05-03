echo "Configuring this workspace as a mock setup"

MOCK_FLAG_FILE="is-mock-setup.txt"

echo "Flag file: $PWD/$MOCK_FLAG_FILE"

echo "true" > $MOCK_FLAG_FILE

sh init-mock-systemctl.sh

echo "Done"