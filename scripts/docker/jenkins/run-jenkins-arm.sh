docker stop jenkins || echo "Skipping stop"
docker rm jenkins || echo "Skipping remove" 

docker pull compulsivecoder/jenkins-arm-iot-mono && \

docker run -d --name=jenkins --restart always -p 8080:8080 -p 50000:50000 -v /usr/local/jenkins:/usr/local/jenkins -v /var/run/docker.sock:/var/run/docker.sock compulsivecoder/jenkins-arm-iot-mono
