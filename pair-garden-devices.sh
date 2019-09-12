

echo ""
echo "Pairing garden devices..."

sh start-plug-and-play-service.sh

sh "wait-for-plug-and-play.sh" # In quotes to avoid editor color coding issue

sh stop-plug-and-play-service.sh

echo "Finished pairing garden devices."
echo ""

