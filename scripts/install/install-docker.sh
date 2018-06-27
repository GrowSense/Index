MOCK_FLAG_FILE="../../is-mock-setup.txt"

if ! type "docker" > /dev/null; then
  if [ ! -f "$MOCK_FLAG_FILE" ]; then
    curl https://get.docker.com/ | sh -s
  else
    echo "Mock setup. Skipping docker install."
  fi
else
  echo "Docker is already installed. Skipping."
fi

sudo usermod -aG docker $USER

