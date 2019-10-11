echo "Starting build for project tests"
echo "  Dir: $PWD"

DIR=$PWD

xbuild /p:Configuration=Release /p:TargetFrameworkVersion=v4.5 src/GrowSense.Index.sln /verbosity:quiet || exit 1

echo "Finished building project tests."
