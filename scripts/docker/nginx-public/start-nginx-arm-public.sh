echo ""
echo "Starting nginx public server via docker"
echo ""

PUBLIC_DIR=$PWD/../../../public/

echo $PUBLIC_DIR

mkdir -p $PUBLIC_DIR
docker run -i --rm --name greensense-test-results -p 8081:80 -v $PUBLIC_DIR:/usr/share/nginx/html:ro -v $PWD/nginx.conf:/etc/nginx/nginx.conf:ro -i zsoltm/nginx-armhf
