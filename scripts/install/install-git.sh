echo "Installing git..."

NEEDS_INSTALL=0

if ! type "git" &>/dev/null; then
  echo "  Git is not installed..."
  NEEDS_INSTALL=1
else
  echo "  Git is already installed..."

  VERSION=$(git --version)

  echo "  Version info:"
  echo "    $VERSION"
fi


#if [[ "$VERSION" != *" 2."* ]]; then
#  echo "  Git needs to be updated..."
#  NEEDS_INSTALL=1
#else
#  echo "  Git is up to date..."
#fi

if [ "$NEEDS_INSTALL" == "1" ]; then
  echo ""
  echo "Installing git"

  if [ -z "$(find /var/cache/apt/pkgcache.bin -mmin -10080)" ]; then
    apt-get update || exit 1
  fi

#  apt-get remove -y git
#  apt-get install -y software-properties-common || echo "Failed to install. Skipping"
#  add-apt-repository -y ppa:git-core/ppa || exit 1
#  apt-get update || exit 1
  apt-get install -y git || exit 1

  git --version || exit 1
fi

echo "Finished installing git."
