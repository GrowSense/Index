echo "Starting build for project tests"
echo "Dir: $PWD"

DIR=$PWD

msbuild src/GreenSense.Index.sln /p:Configuration=Release
