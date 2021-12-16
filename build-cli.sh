echo "Building GrowSense Index CLI"

#msbuild /t:restore /p:Configuration=Release /p:TargetFrameworkVersion=v4.8 /p:RestorePackagesConfig=true /verbosity:detailed src/GrowSense.CLI/GrowSense.CLI.sln  || exit 1
msbuild /p:Configuration=Release /p:TargetFrameworkVersion=v4.5 src/GrowSense.CLI/GrowSense.CLI.sln  || exit 1

echo "Build GrowSense Index CLI complete"
