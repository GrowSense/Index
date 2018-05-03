if ! type "pio" > /dev/null; then
  sudo apt-get install -y python python-pip && \

  pip install --upgrade pip && \
  pip install setuptools testresources && \

  sudo python -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"
else
  echo "Platform.io is already installed. Skipping."
fi
