#!/bin/sh

set -o errexit
set -o nounset
DIR="$(dirname $0)"

sudo "$DIR"/01_distro-configure.sh
sudo "$DIR"/02_packages.sh

"$DIR"/03_flatpak.sh
"$DIR"/04_dotfiles.sh
"$DIR"/05_syncthing.sh
