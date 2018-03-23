echo "Retrieving required libraries..."

if [ ! -f nuget.exe ]; then
    echo "nuget.exe not found. Downloading..."
    wget http://nuget.org/nuget.exe
fi

mono nuget.exe update -self

echo "Installing libraries..."

CONFIG_FILE="BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config";
CONFIG_FILE_TMP="BridgeArduinoSerialToMqttSplitCsv.exe.config";


if [ -f $CONFIG_FILE ]; then
  echo "Config file found. Preserving."

  cp $CONFIG_FILE $CONFIG_FILE_TMP
fi

#rm BridgeArduinoSerialToMqttSplitCsv -r

mono nuget.exe install BridgeArduinoSerialToMqttSplitCsv -ExcludeVersion
mono nuget.exe update BridgeArduinoSerialToMqttSplitCsv

echo "Installation complete. Launching deployer."

if [ -f $CONFIG_FILE_TMP ]; then
  echo "Preserved config file found. Restoring."

  cp $CONFIG_FILE_TMP $CONFIG_FILE
fi

mono BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe $1 $2 $3 $4 $5
