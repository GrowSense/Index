echo "Retrieving required libraries..."

if [ ! -f nuget.exe ]; then
    echo "nuget.exe not found. Downloading..."
    wget http://nuget.org/nuget.exe
fi

mono nuget.exe update -self

echo "Installing libraries..."

mono nuget.exe install GitDeployer -ExcludeVersion
mono nuget.exe update GitDeployer

echo "Installation complete"
