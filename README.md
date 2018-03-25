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


# Commands
## Clone index with submodules
```
git clone --recursive git://github.com/GreenSense/Index.git GreenSense/Index

cd GreenSense/Index
```

## Prepare host computer
```
sudo sh prepare.sh
```

## Initialize libraries
```
sh init.sh
```

## Set MQTT credentials
```
sh set-mqtt-credentials.sh [Username] [Password]

sh set-mqtt-credentials.sh myuser mypass
```

## Set up garden
Set up the mosquitto MQTT broker.
Note: Set the MQTT credentials above first.
```
sh create-garden.sh
```

## Disable garden
Disable the mosquitto MQTT broker
```
sh disable-garden.sh
```


## Create monitor device
Set up a GreenSense monitor device including MQTT bridge and automatic updater.
Note: Ensure the device is connected
```
sh create-garden-monitor.sh [DeviceName] [Port]

sh create-garden-monitor.sh monitor1 ttyUSB0
```

## Create irrigator device
Set up a GreenSense irrigator device including MQTT bridge and automatic updater.
Note: Ensure the device is connected
```
sh create-garden-irrigator.sh [DeviceName] [Port]

sh create-garden-irrigator.sh irrigator1 ttyUSB1
```

## View device updater service log
Display the log from the automatic updater service for a device.
```
sh view-updater-log.sh [DeviceName]

sh view-updater-log.sh monitor1

sh view-updater-log.sh irrigator1
```
Note: Press CTRL+C to exit back to terminal.

## View MQTT bridge service log
Display the log from the MQTT bridge service for a device.
```
sh view-mqtt-bridge-log.sh [DeviceName]

sh view-mqtt-bridge-log.sh monitor1

sh view-mqtt-bridge-log.sh irrigator1
```
Note: Press CTRL+C to exit back to terminal.

## Disable device
Disable the MQTT bridge and automatic updater for a device.
```
sh disable-garden-device.sh [DeviceName]

sh disable-garden-device.sh monitor1

sh disable-garden-device.sh irrigator1
```

# Remove device
Remove the MQTT bridge and automatic updater service files for a device.
Note: This removes the service file from the GreenSense index but does not disable the service. Run the disable script first to disable the service.
```
sh disable-garden-device.sh [DeviceName]

sh disable-garden-device.sh monitor1

sh disable-garden-device.sh irrigator1
