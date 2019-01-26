echo "Updating nuget.exe..."

mono nuget.exe update -self || echo "Failed to update nuget.exe"
