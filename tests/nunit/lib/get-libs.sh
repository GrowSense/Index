echo "Getting library files"
echo "  Dir: $PWD"

LIB_DIR=$PWD

NUGET_FILE="nuget.exe"

if [ ! -f "$NUGET_FILE" ];
then
    echo "Getting nuget.exe..."
    wget http://nuget.org/nuget.exe -q
fi

echo "Updating nuget.exe..."
mono nuget.exe update -self

if [ ! -d "NUnit.2.6.4" ]; then
    mono nuget.exe install nunit -version 2.6.4
fi

if [ ! -d "NUnit.Runners.2.6.4" ]; then
    mono nuget.exe install nunit.runners -version 2.6.4
fi

if [ ! -d "Newtonsoft.Json.11.0.2" ]; then
    mono nuget.exe install newtonsoft.json
fi
