
CONNECTION_TYPE=$1

if [ ! "$CONNECTION_TYPE" ]; then
  echo "Specify the network connection type as an argument."
  exit 1
fi

echo "Setting network connection type..."
echo "  Network connection type: $CONNECTION_TYPE"

echo $CONNECTION_TYPE > network-connection-type.txt

echo "Finished setting network connection type."

