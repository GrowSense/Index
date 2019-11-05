echo "Installing python..."

# python
if ! type "python" > /dev/null; then
  $SUDO apt-get install -y python
else
  echo "  Python is already installed. Skipping install."
fi

# pip
if ! type "pip" &>/dev/null; then
  echo "  Installing pip..."

  $SUDO apt-get install -y python-pip
else
  echo "  Pip is already installed. Skipping install."
fi

# Disabled because it's slow and may not be needed
#echo "  Upgrading python pip..."
#pip install --upgrade pip
#pip install -U requests

echo "Finished installing python."