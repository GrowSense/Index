# python
if ! type "python" > /dev/null; then
  echo "Installing python"

  sudo apt-get install -y python
fi

if ! type "pip" > /dev/null; then
  echo "Installing python-pip"

  sudo apt-get install -y python-pip
fi

echo "Upgrading pip"

sudo chown $USER ~/.cache/pip -R

sudo pip install --ignore-installed --upgrade pip

echo "Installing pip setuptools"

pip install --ignore-installed --user setuptools

if ! type "pio" > /dev/null; then
  echo "Installing platformio"

  pip install --ignore-installed -U platformio

#  python -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"
else
  echo "Platform.io is already installed. Skipping."
fi
