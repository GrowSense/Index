echo "Installing mono..."

if ! type "xbuild" &>/dev/null; then
#  if [ ! $USE_MONO4 ]; then
#    echo "  Environment variable USE_MONO4 not set. Checking for use-mono4.txt file..."
#    if [ -f "use-mono4.txt" ]; then
#      USE_MONO4=1
#    else
#      USE_MONO4=0
#    fi
#  fi
  
#  echo "  USE_MONO4=$USE_MONO4"

#  if [ $USE_MONO4 = 1 ]; then
#    echo ""
    echo "  Installing mono 4"
    sudo apt-get update -qq && sudo apt-get install -y tzdata mono-devel mono-complete ca-certificates-mono || exit 1
#  else
#    echo ""
#    echo "  Installing latest mono"
#    VERSION_NAME=$(lsb_release -cs)
    
#    echo ""
#    echo "  Distribution version: $VERSION_NAME"
    
#    echo ""
#    sudo apt-get update -qq && apt-get -y install apt-transport-https dirmngr gnupg ca-certificates || exit 1
  
#    echo ""
#    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF || exit 1
#    echo "deb http://download.mono-project.com/repo/ubuntu stable-$VERSION_NAME main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list || exit 1
  
#    echo ""
#    sudo apt-get update -qq && sudo apt-get install -y mono-devel mono-complete ca-certificates-mono msbuild || exit 1
#  fi
  
else
  echo "  Mono is already installed. Skipping install."
fi

if ! type "xsp4" &>/dev/null; then
    echo "  Installing mono xsp4"
    sudo apt-get install -y tzdata mono-xsp4 || exit 1
else
  echo "  Mono xsp4 is already installed. Skipping install."
fi


echo ""
echo "  Checking mono version..."
mono --version

echo "Finished installing mono."
