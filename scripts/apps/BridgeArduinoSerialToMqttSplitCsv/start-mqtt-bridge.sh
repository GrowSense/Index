echo "Retrieving required libraries..."

if [ ! -f nuget.exe ]; then
    echo "nuget.exe not found. Downloading..."
    wget http://nuget.org/nuget.exe
fi

mono nuget.exe update -self

echo "Installing libraries..."

#rm BridgeArduinoSerialToMqttSplitCsv/Brid -r

mono nuget.exe install BridgeArduinoSerialToMqttSplitCsv -ExcludeVersion

echo "Installation complete. Launching deployer."

mono BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe $1 $2 $3 $4 $5
