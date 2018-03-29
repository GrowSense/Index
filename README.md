# GreenSense Project Index
This is an index of GreenSense related projects and utilities.

Connect GreenSense projects to a host computer, clone this index onto it, and then you're ready to build and upload sketches.



|               |               | master | dev |
| ------------- | ------------- | ------------- | ------------- |
| **Sanity Tests**  |               |               |               |
|               | Travis CI Test  | [![Build Status](https://travis-ci.org/GreenSense/SanityTests.svg?branch=master)](https://travis-ci.org/GreenSense/Index) |  |
|               | Jenkins Test  | [![Build Status](http://greensense.hopto.org:8090/job/GreenSense/job/SanityTests/job/master/badge/icon)](http:/greensense.hopto.org:8090/job/GreenSense/job/SanityTests/job/master/)  |   |
| **Index**  |               |               |               |
|               | Travis CI Build  | [![Build Status](https://travis-ci.org/GreenSense/Index.svg?branch=master)](https://travis-ci.org/GreenSense/Index) | [![Build Status](https://travis-ci.org/GreenSense/Index.svg?branch=dev)](https://travis-ci.org/GreenSense/Index) |
| **Monitor**  |               |               |               |
|               | Travis CI Build  | [![Build Status](https://travis-ci.org/GreenSense/SoilMoistureSensorCalibratedSerial.svg?branch=master)](https://travis-ci.org/GreenSense/SoilMoistureSensorCalibratedSerial)  | [![Build Status](https://travis-ci.org/GreenSense/SoilMoistureSensorCalibratedSerial.svg?branch=dev)](https://travis-ci.org/GreenSense/SoilMoistureSensorCalibratedSerial)  |
|               | Jenkins Hardware Test  | [![Build Status](http://greensense.hopto.org:8080/job/GreenSense/job/SoilMoistureSensorCalibratedSerial/job/master/badge/icon)](http:/greensense.hopto.org:8080/job/GreenSense/job/SoilMoistureSensorCalibratedSerial/job/master/)  | [![Build Status](http://greensense.hopto.org:8080/job/GreenSense/job/SoilMoistureSensorCalibratedSerial/job/dev/badge/icon)](http:/greensense.hopto.org:8080/job/GreenSense/job/SoilMoistureSensorCalibratedSerial/job/dev/)  |
| **Irrigator**  |               |               |               |
|               | Travis CI Build  | [![Build Status](https://travis-ci.org/GreenSense/SoilMoistureSensorCalibratedPump.svg?branch=master)](https://travis-ci.org/GreenSense/SoilMoistureSensorCalibratedPump)  | [![Build Status](https://travis-ci.org/GreenSense/SoilMoistureSensorCalibratedPump.svg?branch=dev)](https://travis-ci.org/GreenSense/SoilMoistureSensorCalibratedPump)  |
|               | Jenkins Hardware Test  | [![Build Status](http://greensense.hopto.org:8080/job/GreenSense/job/SoilMoistureSensorCalibratedPump/job/master/badge/icon)](http:/greensense.hopto.org:8080/job/GreenSense/job/SoilMoistureSensorCalibratedPump/job/master/)  | [![Build Status](http://greensense.hopto.org:8080/job/GreenSense/job/SoilMoistureSensorCalibratedPump/job/dev/badge/icon)](http:/greensense.hopto.org:8080/job/GreenSense/job/SoilMoistureSensorCalibratedPump/job/dev/)  |
| **MQTT Bridge**  |               |               |               |
|               | Travis CI Build  | [![Build Status](https://travis-ci.org/CompulsiveCoder/BridgeArduinoSerialToMqttSplitCsv.svg?branch=master)](https://travis-ci.org/CompulsiveCoder/BridgeArduinoSerialToMqttSplitCsv)  | [![Build Status](https://travis-ci.org/CompulsiveCoder/BridgeArduinoSerialToMqttSplitCsv.svg?branch=dev)](https://travis-ci.org/CompulsiveCoder/BridgeArduinoSerialToMqttSplitCsv)  |
| **Updater**  |               |               |               |
|               | Travis CI Build  | [![Build Status](https://travis-ci.org/CompulsiveCoder/GitDeployer.svg?branch=master)](https://travis-ci.org/CompulsiveCoder/GitDeployer)  | [![Build Status](https://travis-ci.org/CompulsiveCoder/GitDeployer.svg?branch=dev)](https://travis-ci.org/CompulsiveCoder/GitDeployer)  |


# Clone and Setup

## Automatic Clone and Initialize
```
# Prepare the workspace
mkdir ~/workspace
cd ~/workspace

# Clone and Setup
curl https://raw.githubusercontent.com/GreenSense/Index/master/setup-from-github.sh | sh -s
cd GreenSense/Index
```
Note: The above script will automatically run the prepare.sh and init.sh scripts so they don't need to be run again.
After it completes, skip past the "Manual Clone and Initialize" section down to the "Set Up Garden" section below.

## Manual Clone and Initialize
### Clone Index with Submodules
```
git clone --recursive git://github.com/GreenSense/Index.git GreenSense/Index

cd GreenSense/Index
```

### Prepare Host Computer
```
sudo sh prepare.sh
```

### Initialize Libraries
```
sh init.sh
```

## Set Up Garden
### Set MQTT Credentials
Set the username and password used by the MQTT broker and MQTT bridge.
```
sh set-mqtt-credentials.sh [Username] [Password]

sh set-mqtt-credentials.sh myuser mypass
```

### Set Up Garden Services
Set up the mosquitto MQTT broker.
Note: Set the MQTT credentials above first.
```
sh create-garden.sh
```

### Disable Garden Services
Disable the mosquitto MQTT broker if it needs to be stopped.
```
sh disable-garden.sh
```

### Reset Garden Cache
Removes the MQTT bridge and updater service cache and temporary files. This is useful if a service isn't running properly.
Note: This will force the updater to re-update the connected devices.
```
sh remove-cache.sh
```

## Create and Manage Garden Devices
### Create monitor device
Set up a GreenSense monitor device including MQTT bridge and automatic updater.
Note: Ensure the device is connected
```
sh create-garden-monitor.sh [DeviceName] [Port]

sh create-garden-monitor.sh monitor1 ttyUSB0
```

### Create irrigator device
Set up a GreenSense irrigator device including MQTT bridge and automatic updater.
Note: Ensure the device is connected
```
sh create-garden-irrigator.sh [DeviceName] [Port]

sh create-garden-irrigator.sh irrigator1 ttyUSB1
```

### View device updater service log
Display the log from the automatic updater service for a device.
```
sh view-updater-log.sh [DeviceName]

sh view-updater-log.sh monitor1

sh view-updater-log.sh irrigator1
```
Note: Press CTRL+C to exit back to terminal.

### View MQTT bridge service log
Display the log from the MQTT bridge service for a device.
```
sh view-mqtt-bridge-log.sh [DeviceName]

sh view-mqtt-bridge-log.sh monitor1

sh view-mqtt-bridge-log.sh irrigator1
```
Note: Press CTRL+C to exit back to terminal.

### Restart Garden Device
Restart MQTT bridge and updater services for a device.
```
sh restart-garden-device.sh [DeviceName]

sh restart-garden-device.sh monitor1

sh restart-garden-device.sh irrigator1
```

### Disable Garden Device
Disable the MQTT bridge and automatic updater for a device.
Note: This doesn't remove the device only temporarily disables it.
```
sh disable-garden-device.sh [DeviceName]

sh disable-garden-device.sh monitor1

sh disable-garden-device.sh irrigator1
```

### Remove Garden Device
Remove the MQTT bridge and automatic updater service files for a device.
Note: This disables and completely removes the device service files.
```
sh remove-garden-device.sh [DeviceName]

sh remove-garden-device.sh monitor1

sh remove-garden-device.sh irrigator1
```

### Remove All Garden Devices
Remove all services for all garden devices found.
```
sh remove-garden-devices.sh
```

## Mobile UI

### Install Linear MQTT Dashboard 
The Linear MQTT Dashboard application will be the user interface for the GreenSense projects.
- Go to the play store
- Search for "linear mqtt"
- Install the "Linear MQTT Dashboard" application.

### Install Termux
Termux is linux style terminal for mobile applications, and will be used to import the Linear MQTT Dashboard config file.
- Go to the play store
- Search for "termux"
- Install the "Termux" application.

### Import config.linear file
- Open Termux
- Install OpenSSH
```
pkg install -y openssh
```
- Import the config.linear file (automatically generated when creating garden devices using the steps above).
```
# Format:
scp [user]@[host]:~/workspace/GreenSense/Index/mobile/linearmqtt/output/config.linear config.linear
# Example:
scp j@garden:~/workspace/GreenSense/Index/mobile/linearmqtt/output/config.linear config.linear
```
- Open the config.linear file
```
termux-open config.linear
```
- The Linear MQTT Dashboard should open and ask if you want to import the configuration.
- Select YES
- The GreenSense user interface should now be displayed.
