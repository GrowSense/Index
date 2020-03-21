#!/bin/bash

MOCK_FLAG_FILE="is-mock-journalctl.txt"

if [ ! -f $MOCK_FLAG_FILE ]; then
  SUDO=""
  if [ ! "$(id -u)" -eq 0 ]; then
    if [ ! -f "is-mock-sudo.txt" ]; then
      SUDO='sudo'
    fi
  fi
  $SUDO journalctl $1 $2 $3 $4 $5 $6 $7
else
  echo "[mock] sudo journalctl $1 $2 $3 $4 $5 $6 $7"
fi
