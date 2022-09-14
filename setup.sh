#!/usr/bin/env sh
SCRIPT_PATH=$(dirname "$0")
IDENT=$(cat ident)

echo "setup.sh: rm $SCRIPT_PATH/flake.lock"
rm $SCRIPT_PATH/flake.lock
echo "setup.sh: nixos-rebuild switch --flake .#$IDENT"
sudo nixos-rebuild switch --flake .#$IDENT
echo "setup.sh: Done."
