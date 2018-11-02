echo "Retrieving required libraries..."

# Nuget is disabled
# sh get-nuget.sh
# sh nuget-update-self.sh

echo "Installing libraries..."

mono nuget.exe install GitDeployer 10.0.0.20 || exit 1

echo "Installation complete"
