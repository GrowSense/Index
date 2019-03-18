#!/bin/sh

MOCK_FLAG_FILE="is-mock-systemctl.txt"

if [ ! -f $MOCK_FLAG_FILE ]; then
  SUDO=""
  if [ ! "$(id -u)" -eq 0 ]; then
      SUDO='sudo'
  fi
  $SUDO systemctl $1 $2 $3
else
  echo "[mock] sudo systemctl $1 $2 $3"
fi
