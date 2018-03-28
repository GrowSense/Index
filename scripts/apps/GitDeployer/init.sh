echo "Retrieving required libraries..."

if [ ! -f nuget.exe ]; then
    echo "nuget.exe not found. Downloading..."
    wget http://nuget.org/nuget.exe || exit 1
fi

mono nuget.exe update -self || exit 1

echo "Installing libraries..."

mono nuget.exe install GitDeployer -ExcludeVersion || exit 1

echo "Installation complete"
