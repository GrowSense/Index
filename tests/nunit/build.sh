echo "Starting build for project tests"
echo "Dir: $PWD"

DIR=$PWD

xbuild /p:Configuration=Release /p:TargetFrameworkVersion=v4.5 /p:TargetFrameworkProfile="" src/GreenSense.Index.sln
