echo "Retrieving required libraries..."

if [ ! -f nuget.exe ]; then
    echo "nuget.exe not found. Downloading..."
    wget http://nuget.org/nuget.exe
fi

mono nuget.exe update -self

echo "Installing libraries..."

rm GitDeployer -r

mono nuget.exe install GitDeployer -ExcludeVersion

echo "Installation complete. Launching deployer."

mono GitDeployer/lib/net40/GitDeployer.exe $1 $2 $3 $4 $5
