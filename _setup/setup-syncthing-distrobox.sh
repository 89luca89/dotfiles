#!/bin/sh

if [ "$(id -ru)" -eq 0 ]; then
	echo "Please run WITHOUT ROOT"
	exit
fi
set -o errexit
set -o nounset

sudo dnf install -y syncthing
distrobox-export --service synthing
systemctl --user enable --now syncthing-syncthing
