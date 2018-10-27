if ! type "jq" > /dev/null; then
  apt-get -y install jq
else
  echo "jq is already installed. Skipping install."
fi

if ! jq --version | grep '1.5'; then
  echo "jq 1.5 not found. Upgrading"
  add-apt-repository -y ppa:eugenesan/ppa
  apt-get update
  apt-get -y install jq
  apt-get -y upgrade
fi

if ! jq --version | grep '1.5'; then
  echo "jq 1.5 still not found. Upgrading from source"
  wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz
  tar xzf jq-1.5.tar.gz
  cd jq-1.5/
  sudo ./configure && sudo make && sudo make install
fi