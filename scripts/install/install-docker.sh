if ! type "docker" > /dev/null; then
  curl https://get.docker.com/ | sh -s
  sudo usermod -aG docker $USER
else
  echo "Docker is already installed. Skipping."
fi

