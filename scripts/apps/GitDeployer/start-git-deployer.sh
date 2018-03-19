echo "Retrieving required libraries..."

if [ ! -f nuget.exe ]; then
    echo "nuget.exe not found. Downloading..."
    wget http://nuget.org/nuget.exe
fi

mono nuget.exe update -self

echo "Installing libraries..."

VERSION="1.0.0.8"

if [ ! -d "GitDeployer.$VERSION" ]; then
mono nuget.exe install GitDeployer -version $VERSION
fi

echo "Installation complete. Launching deployer."

mono GitDeployer.$VERSION/lib/net40/GitDeployer.exe $1 $2 $3 $4 $5
