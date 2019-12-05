echo "Launching command in background..."
echo "Command:"
echo "  nohup $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} 2>&1 &"
echo ""

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

$SUDO bash -c "nohup $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} 2>&1 &"
echo ""
echo "Finished launching command in background"