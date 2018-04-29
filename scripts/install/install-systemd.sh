MOCK_FLAG_FILE="../../is-mock-setup.txt"

if ! type "systemd" > /dev/null; then
  if [ ! -f "$MOCK_FLAG_FILE" ]; then
    sudo apt-get install -y systemd
  else
    echo "Mock setup. Skipping systemd install."
  fi
else
  echo "systemd is already installed. Skipping install."
fi
