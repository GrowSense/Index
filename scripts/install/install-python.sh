echo "Installing python..."

# python
if ! type "python3" > /dev/null; then
  echo "  Installing python3..."
  $SUDO apt-get install -y python3
else
  echo "  Python is already installed. Skipping install."
fi

# pip
if ! type "pip3" &>/dev/null; then
  echo "  Installing pip3..."

  $SUDO apt-get install -y python3-pip
else
  echo "  Pip is already installed. Skipping install."
fi

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

python3 $CURRENT_DIR/install-python-modules.py

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# Disabled because it's slow and may not be needed
#echo "  Upgrading python pip..."
#pip install --upgrade pip
#pip install -U requests

echo "Finished installing python."
