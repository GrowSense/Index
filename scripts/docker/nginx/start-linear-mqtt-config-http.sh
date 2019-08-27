
echo "Starting nginx to expose the Linear MQTT Dashboard UI config file via HTTP"

#docker stop greensense-ui-http
#docker rm greensense-ui-http

PORT="8888"

echo "Port: $PORT"

PUBLIC_DIR="$PWD/../../../mobile/linearmqtt/output/"
#PUBLIC_DIR="$PWD/test"

docker pull compulsivecoder/nginx-arm

docker run -d --restart always --name greensense-ui-http -p $PORT:80 -v $PUBLIC_DIR:/usr/share/nginx/html:ro -v $PWD/nginx.conf:/etc/nginx/nginx.conf:ro -i compulsivecoder/nginx-arm

echo "View it at:"
echo "Syntax:"
echo "  http://[host]:$PORT"
echo "Example:"
echo "  http://localhost:$PORT"
echo "  http://garden:$PORT"
echo "  http://10.0.0.8:$PORT"
echo "Done"
