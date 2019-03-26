MOCK_FLAG_FILE="../../is-mock-docker.txt"

if ! type "docker" > /dev/null; then
  if [ ! -f "$MOCK_FLAG_FILE" ]; then
    curl https://get.docker.com/ | sh -s
    
    usermod -aG docker $USER
  else
    echo "Is mock docker. Skipping docker install."
  fi
else
  echo "Docker is already installed. Skipping."
fi

