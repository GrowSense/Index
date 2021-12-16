echo "Building entire index"

xbuild /p:Configuration=Release /p:TargetFrameworkVersion=v4.5 src/GrowSense.CLI/GrowSense.CLI.sln  || exit 1

echo "Build index complete"
