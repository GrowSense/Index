echo "Installing python..."

# python
#if ! type "python" > /dev/null; then
#  echo "  Installing python..."
#  $SUDO apt-get install -y python python-setuptools python-serial || exit 1
#else
#  echo "  Python is already installed. Skipping install."
#fi

echo "Installing python3..."

# python3
if ! type "python3" > /dev/null; then
  echo "  Installing python3..."
  $SUDO apt-get install -y python3 python3-setuptools python3-serial || exit 1
else
  echo "  python3 is already installed. Skipping install."
fi

#echo "Installing pip..."

# pip
#if ! type "pip" &>/dev/null; then
#  echo "  Installing pip..."

#  $SUDO apt-get install -y python-pip || exit 1
#else
#  echo "  Pip is already installed. Skipping install."
#fi

echo "Installing pip3..."

# pip3
if ! type "pip3" &>/dev/null; then
  echo "  Installing pip3..."

  $SUDO apt-get install -y python3-pip || exit 1
else
  echo "  pip3 is already installed. Skipping install."
fi

echo "Installing python3-setuptools and python3-serial"

# python tools/modules
#$SUDO apt-get install -y python-setuptools python-serial python3-setuptools python3-serial
$SUDO apt-get install -y python3-setuptools python3-serial

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

python3 -m pip install --upgrade requests

#python3 $CURRENT_DIR/install-python-modules.py || exit 1
python3 $CURRENT_DIR/install-python-modules.py || echo "Error installing python modules"

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# Disabled because it's slow and may not be needed
#echo "  Upgrading python pip..."
#pip install --upgrade pip
#pip install -U requests

echo "Finished installing python."

