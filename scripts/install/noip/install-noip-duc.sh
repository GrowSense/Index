# Note: Run as sudo

echo "Installing no-ip updater client to:"

DIR=$PWD

cd /usr/local/src
wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
tar xzf noip-duc-linux.tar.gz
cd noip-2.1.9-1
sudo make
sudo make install

sudo cp $DIR/service/noip /etc/init.d/noip
sudo chmod a+x /etc/init.d/noip
sudo update-rc.d noip defaults
#sudo service noip configure # Gets configured during install so this shouldnt be needed
sudo service noip start
sudo service noip status
