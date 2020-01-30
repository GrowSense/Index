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
  echo "  Is Raspberry Pi running Raspbian. Installing hotspot..."

  DIR="$PWD"

  cd /usr/local/sbin
  if [ -f "hotspot" ]; then
    rm hotspot
  fi
  wget https://raw.githubusercontent.com/rudiratlos/hotspot/master/hotspot
  chmod +x hotspot
  apt-get -y update
  apt-get -y upgrade
  hotspot setup

  cd "$DIR"
else
  echo "  Is not Raspberry Pi running Raspbian. Skipping hotspot install."
fi

echo "Finished installing hotspot."
