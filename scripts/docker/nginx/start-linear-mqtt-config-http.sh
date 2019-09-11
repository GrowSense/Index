
echo "Starting nginx to expose the Linear MQTT Dashboard UI config file via HTTP"

#docker stop greensense-ui-http
#docker rm greensense-ui-http

PORT="80"

echo "Port: $PORT"

PUBLIC_DIR="$PWD/../../../mobile/linearmqtt/output/"
#PUBLIC_DIR="$PWD/test"

# compulsivecoder/nginx-arm is disabled because it doesn't work on Raspbian
#docker pull compulsivecoder/nginx-arm
docker pull tobi312/rpi-nginx

# compulsivecoder/nginx-arm is disabled because it doesn't work on Raspbian
#docker run -d --restart always --name greensense-ui-http -p $PORT:80 -v $PUBLIC_DIR:/usr/share/nginx/html:ro -v $PWD/nginx.conf:/etc/nginx/nginx.conf:ro -i compulsivecoder/nginx-arm
docker run --name greensense-ui-http -d --restart always -p $PORT:80 -p 443:443 -v $PWD/config:/etc/nginx/conf.d:ro -v $PUBLIC_DIR:/var/www/html tobi312/rpi-nginx

echo "View it at:"
echo "Syntax:"
echo "  http://[host]:$PORT"
echo "  http://[ipaddress]:$PORT"
echo "Example:"
echo "  http://localhost:$PORT"
echo "  http://garden:$PORT"
echo "  http://10.0.0.8:$PORT"
echo "Done"
