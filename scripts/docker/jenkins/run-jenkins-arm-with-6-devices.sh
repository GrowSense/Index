docker stop jenkins || echo "Jenkins not found. Skipping stop"
docker rm jenkins || echo "Jenkins not found. Skipping remove"

docker run -d --name=jenkins --restart=always -p 8080:8080 -p 50000:50000 --device /dev/ttyUSB0 --device /dev/ttyUSB1 --device /dev/ttyUSB2 --device /dev/ttyUSB3 --device /dev/ttyUSB4 --device /dev/ttyUSB5 -v /usr/local/jenkins:/usr/local/jenkins -v /var/run/docker.sock:/var/run/docker.sock compulsivecoder/jenkins-arm-iot-mono

docker pull compulsivecoder/jenkins-arm-iot-mono

