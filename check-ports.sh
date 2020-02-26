echo "Checking which ports are configured as GrowSense devices..."
echo ""

pioList=$(pio device list)

currentHost=$(cat /etc/hostname)

while IFS= read -r line; do
  if [[ "$line" == *"/dev/"* ]]; then
    deviceIsConfigured=0
    if [[ -d "devices" ]]; then
      for deviceDir in devices/*; do
        #echo "$deviceDir"
        if [[ -d "$deviceDir" ]]; then
          deviceInfoPort=$(cat $deviceDir/port.txt)
          deviceInfoHost=$(cat $deviceDir/host.txt)
          if [[ "$line" == *"$deviceInfoPort"* ]] && [[ "$currentHost" == "$deviceInfoHost" ]]; then
            deviceIsConfigured=1
            deviceLabel=$(cat $deviceDir/label.txt)
            deviceName=$(cat $deviceDir/name.txt)
          fi
        fi
      done
    fi

    if [ "$deviceIsConfigured" == "0" ]; then
      echo "$line"
      echo "  Not configured"
    else
      echo "$line"
      echo "  Label: $deviceLabel"
      echo "  Name: $deviceName"
    fi

    echo ""
  fi
done <<< "$pioList"

echo "Finished checking which ports are configured as GrowSense devices."
