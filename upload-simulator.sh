#!/bin/bash

#. ./common.sh

SIMULATOR_PORT=$1

if [ ! $SIMULATOR_PORT ]; then
  echo "Specify a port as an argument"
  exit 1
fi

echo "Uploading simulator to port $SIMULATOR_PORT"

# Specify a temporary directory name
SIMULATOR_TMP_DIR="_simulatortmp"

# Remove old versions
rm -rf $SIMULATOR_TMP_DIR

# Make a new directory
mkdir -p $SIMULATOR_TMP_DIR
cd $SIMULATOR_TMP_DIR

# Clone the latest version
git clone https://github.com/CompulsiveCoder/ArduinoSerialController.git && \

cd ArduinoSerialController && \

# Upload
sh upload-to-port.sh "$SIMULATOR_PORT" && \

# Remove the temporary directory
rm -rf $SIMULATOR_TMP_DIR
