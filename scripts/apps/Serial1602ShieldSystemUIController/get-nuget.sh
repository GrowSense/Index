NUGET_FILE="nuget.exe"

if [ ! -f "$NUGET_FILE" ];
then
    echo "Getting $NUGET_FILE..."
    wget http://nuget.org/$NUGET_FILE -q
fi
