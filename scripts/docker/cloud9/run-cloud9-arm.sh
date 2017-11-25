HOST_PORT="8181"
WORKSPACE_PATH="/home/$USER/workspace/GreenSense/Index"

# No authentication
#docker run --name rpi-cloud9-ide -it -d -p $HOST_PORT:8181 -v $WORKSPACE_PATH:/workspace hwegge2/rpi-cloud9-ide node server.js -w/workspace --listen 0.0.0.0 -a :

USERNAME="user"
PASWORD="pass1234"

# Authenticated by username and password
docker run --name rpi-cloud9-ide -it -d -p $HOST_PORT:8181 -v $WORKSPACE_PATH:/workspace hwegge2/rpi-cloud9-ide node server.js -w/workspace --listen 0.0.0.0 -a $USERNAME:$PASSWORD
