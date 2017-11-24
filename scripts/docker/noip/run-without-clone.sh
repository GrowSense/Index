sudo docker run --name=noip -it -v /etc/localtime:/etc/localtime -v /home/$USER/noip/config:/config cwmyers/rpi-no-ip

# Edit the ~/noip/config/noip.conf file then re-run the container
