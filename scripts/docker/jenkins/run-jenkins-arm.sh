sudo docker run -dit --restart always -u $USER -p 8080:8080 -p 50000:50000 --device /dev/ttyUSB0 --device /dev/ttyUSB1 -v /home/j/jenkins:/var/jenkins_home reverie/armhf-jenkins
