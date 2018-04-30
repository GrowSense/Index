
if ! type "msbuild" > /dev/null; then
  VERSION_NAME=$(lsb_release -cs)

  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
  echo "deb https://download.mono-project.com/repo/ubuntu stable-$VERSION_NAME main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
  apt-get update && \
  apt-get install -y mono-complete ca-certificates-mono msbuild
else
  echo "Mono/msbuild is already installed. Skipping install."
fi

