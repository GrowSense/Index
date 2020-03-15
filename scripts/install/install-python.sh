echo "Installing python..."

# python
if ! type "python3" > /dev/null; then
  echo "  Installing python3..."
  $SUDO apt-get install -y python3 python3-setuptools python3-serial || exit 1
else
  echo "  Python is already installed. Skipping install."
fi

# pip
if ! type "pip3" &>/dev/null; then
  echo "  Installing pip3..."

  $SUDO apt-get install -y python3-pip || exit 1
else
  echo "  Pip is already installed. Skipping install."
fi

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

python3 $CURRENT_DIR/install-python-modules.py || exit 1

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# Disabled because it's slow and may not be needed
#echo "  Upgrading python pip..."
#pip install --upgrade pip
#pip install -U requests

echo "Finished installing python."
