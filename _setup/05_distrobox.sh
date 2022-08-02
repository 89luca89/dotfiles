#!/bin/sh

if [ "$(id -ru)" -eq 0 ]
  then echo "Please run WITHOUT ROOT"
  exit
fi
set -o errexit
set -o nounset

curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --next --prefix ~/.local

~/.local/bin/distrobox create -i registry.opensuse.org/opensuse/toolbox:latest -n opensuse
~/.local/bin/distrobox create -i registry.fedoraproject.org/fedora:rawhide -n fedora
~/.local/bin/distrobox create -i registry.fedoraproject.org/fedora:rawhide -n syncthing

~/.local/bin/distrobox enter fedora -- ./setup-fedora-distrobox.sh
~/.local/bin/distrobox enter opensuse -- ./setup-opensuse-distrobox.sh
~/.local/bin/distrobox enter opensuse -- ./setup-syncthing-distrobox.sh
