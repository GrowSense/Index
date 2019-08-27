sudo docker run --name=noip --privileged -it -u $USER -v /etc/localtime:/etc/localtime -v /home/j/noip/config:/config cwmyers/rpi-no-ip

# Edit the ~/noip/config/noip.conf file then re-run the container
