
if ! type "msbuild" > /dev/null; then
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
  sudo echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list

  sudo apt-get update && apt-get install -y mono-devel mono-complete ca-certificates-mono msbuild
else
  echo "Mono/msbuild is already installed. Skipping install."
fi
