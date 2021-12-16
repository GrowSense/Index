echo "Building GrowSense Index CLI"

msbuild /t:restore src/GrowSense.CLI/GrowSense.CLI.sln  || exit 1
msbuild /p:Configuration=Release /p:TargetFrameworkVersion=v4.5 /verbosity:detailed src/GrowSense.CLI/GrowSense.CLI.sln  || exit 1

echo "Build GrowSense Index CLI complete"
