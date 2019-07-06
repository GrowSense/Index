MOCK_FLAG_FILE="../../is-mock-docker.txt"

if ! type "docker" > /dev/null; then
  if [ ! -f $MOCK_FLAG_FILE ]; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    chmod u+x get-docker.sh    
    
    BOARD_MODEL="$( cat /proc/device-tree/model )"

    [[ $(echo $BOARD_MODEL) =~ "Raspberry Pi" ]] && IS_RPI=1 || IS_RPI=0

    if [ "$IS_RPI" = "1" ]; then
      VERSION=18.06.3 ./get-docker.sh
    else
      ./get-docker.sh
    fi
    
    usermod -aG docker $USER || "Failed to add user to docker group."
  else
    echo "Is mock docker. Skipping docker install."
  fi
else
  echo "Docker is already installed. Skipping."
fi

