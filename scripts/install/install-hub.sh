
if ! type "hub" > /dev/null; then
  echo "Installing hub..."
  mkdir -p "$GOPATH"/src/github.com/github
  git clone \
    --config transfer.fsckobjects=false \
    --config receive.fsckobjects=false \
    --config fetch.fsckobjects=false \
    https://github.com/github/hub.git "$GOPATH"/src/github.com/github/hub
  cd "$GOPATH"/src/github.com/github/hub
  make install prefix=/usr/local
else
  echo "Hub already installed. Skipping."
fi
