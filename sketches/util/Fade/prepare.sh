#!/bin/bash

# Note: You may need to run this script with sudo

apt-get update &&
apt-get -y install curl python build-essential &&
python -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/develop/scripts/get-platformio.py)"

# Or

#pip install -U platformio
