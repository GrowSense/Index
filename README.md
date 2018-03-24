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


# Clone index with submodules

## One Step Clone
```
git clone --recursive git://github.com/GreenSense/Index.git GreenSense/Index

cd GreenSense/Index
```

## Two Step Clone
```
git clone git://github.com/GreenSense/Index.git GreenSense/Index

cd GreenSense/Index

git submodule update --init --recursive
```
