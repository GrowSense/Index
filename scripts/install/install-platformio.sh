# python
if ! type "python" > /dev/null; then
  sudo apt-get install -y python
fi

if ! type "pip" > /dev/null; then
  sudo apt-get install -y python-pip
fi

if ! type "pio" > /dev/null; then
  sudo python -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"
else
  echo "Platform.io is already installed. Skipping."
fi
