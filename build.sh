echo "Building entire index"

msbuild /p:Configuration=Release /p:TargetFrameworkVersion=v4.5 /verbosity:detailed src/GrowSense.CLI/GrowSense.CLI.sln  || exit 1

echo "Build index complete"
