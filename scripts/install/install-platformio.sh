# NOTE: You may need to run this file as administrator. Example:
# sudo sh install-platformio.sh

sudo apt-get install -y python python-pip && \

sudo pip install --upgrade pip && \
sudo pip install setuptools && \

sudo python -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"
