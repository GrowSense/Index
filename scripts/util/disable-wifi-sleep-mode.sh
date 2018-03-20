echo "Disabling wifi sleep mode"

sudo wget https://gist.githubusercontent.com/jcberthon/ea8cfe278998968ba7c5a95344bc8b55/raw/3082c69fd52ee868887aba6112e88af8f81f872c/wifi-powersave-off.conf -O /etc/NetworkManager/conf.d/wifi-powersave-off-conf
sudo systemctl restart NetworkManager
