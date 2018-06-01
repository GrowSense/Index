# python
if ! type "python" > /dev/null; then
  sudo apt-get install -y python
fi

if ! type "pip" > /dev/null; then
  sudo apt-get install -y python-pip
fi

pip install --upgrade pip
pip install --user setuptools

if ! type "pio" > /dev/null; then
  python -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"
else
  echo "Platform.io is already installed. Skipping."
fi
