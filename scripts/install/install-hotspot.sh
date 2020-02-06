echo "Installing hotspot..."

if [ -f "/etc/os-release" ]; then
  RASPBIAN_INFO="$(cat /etc/os-release | grep -w Raspbian)"
else
  RASPBIAN_INFO=""
fi

if [ "$RASPBIAN_INFO" != "" ]; then
  IS_RASPBIAN=1
else
  IS_RASPBIAN=0
fi

if [ "$IS_RASPBIAN" = "1" ]; then
  if [ ! -f "/usr/local/sbin/hotspot" ]; then
    echo "  Is Raspberry Pi running Raspbian. Installing hotspot..."

    DIR="$PWD"

    cd /usr/local/sbin
    wget https://raw.githubusercontent.com/rudiratlos/hotspot/master/hotspot
    chmod +x hotspot
    apt-get -y update
    apt-get -y upgrade
    hotspot modpar self wipeiptables no
    hotspot modpar self aptaddinstlist ""
    hotspot setup

    cd "$DIR"
  else 
    echo "  Hotspot already installed. Skipping..."
  fi
else
  echo "  Is not Raspberry Pi running Raspbian. Skipping hotspot install."
fi

echo "Finished installing hotspot."
