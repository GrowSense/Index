if type notify-send &>/dev/null; then
  notify-send "$1" "$2" || echo "Failed to send message via notify-send"
else
  echo "notify-send not installed. Skipping."
fi

