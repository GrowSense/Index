

echo ""
echo "Pairing garden devices..."

bash start-plug-and-play-service.sh

bash "wait-for-plug-and-play.sh" # In quotes to avoid editor color coding issue

bash stop-plug-and-play-service.sh

echo "Finished pairing garden devices."
echo ""

