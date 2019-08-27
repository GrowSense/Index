echo "Installing docker...."

MOCK_FLAG_FILE="../../is-mock-docker.txt"

if ! type "docker" &>/dev/null; then
  if [ ! -f $MOCK_FLAG_FILE ]; then
    if [ -f "/etc/os-release" ]; then
      RASPBIAN_INFO="$(cat /etc/os-release | grep -w Raspbian)"
    else
      RASPBIAN_INFO=""
    fi

    if [ "$RASPBIAN_INFO" != "" ]; then
      IS_RPI=1
    else
      IS_RPI=0
    fi
    
    if [ "$IS_RPI" = "1" ]; then
      echo "  Is Raspberry Pi. Installing docker version 18.06.2 for raspbian"
      apt-get -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common

       curl -fsSL https://download.docker.com/linux/raspbian/gpg | apt-key add -

       echo "deb [arch=armhf] https://download.docker.com/linux/raspbian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list

       apt-get update

       apt-get install docker-ce=18.06.2~ce~3-0~raspbian containerd.io
    else
      echo "  Installing latest version of docker..."
      curl -fsSL https://get.docker.com -o get-docker.sh
      chmod u+x get-docker.sh    
      ./get-docker.sh
    fi
    
    usermod -aG docker $USER || "Failed to add user to docker group."
  else
    echo "  Is mock docker. Skipping docker install."
  fi
  echo "Finished installing docker"
else
  echo "  Docker is already installed. Skipping."
fi

