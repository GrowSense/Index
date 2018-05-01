MOCK_FLAG_FILE="is-mock-setup.txt"

if [ ! -f "$MOCK_FLAG_FILE" ]; then
    systemctl $1 $2 $3
else
    echo "[mock] sudo systemctl $1 $2 $3"
fi