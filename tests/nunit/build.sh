echo "Starting build for project tests"
echo "Dir: $PWD"

DIR=$PWD

xbuild src/GreenSense.Index.sln /p:Configuration=Release
