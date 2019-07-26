SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

bash "wait-for-plug-and-play.sh" && \ # In quotes to avoid color coding issue in editor
bash "wait-for-unlock.sh" && \ # In quotes to avoid color coding issue in editor
$SUDO shutdown now
