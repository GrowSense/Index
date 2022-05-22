echo "Building GrowSense Index CLI"

xbuild /t:Clean src/GrowSense.CLI/GrowSense.CLI.sln || exit 1

xbuild /t:Rebuild /p:Configuration=Release /p:TargetFrameworkVersion=v4.0 src/GrowSense.CLI/GrowSense.CLI.sln  || exit 1

echo "Build GrowSense Index CLI complete"
