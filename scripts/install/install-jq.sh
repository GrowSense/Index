if ! type "jq" > /dev/null; then
  add-apt-repository ppa:eugenesan/ppa
  apt-get update
  apt-get -y install jq

else
  echo "jq is already installed. Skipping."
fi

