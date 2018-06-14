if ! type "jq" > /dev/null; then
  apt-get -y install jq

  
  if ! jq --version | grep '1.5'; then
    echo "jq 1.5 not found. Upgrading"
    add-apt-repository -y ppa:eugenesan/ppa
    apt-get update
    apt-get -y install jq
  fi
else
  echo "jq is already installed. Skipping."
fi

