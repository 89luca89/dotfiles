#!/bin/sh

if [ "$(id -ru)" -eq 0 ]; then
	echo   "Please run WITHOUT ROOT"
	exit
fi
set -o errexit
set -o nounset

SYSTEMD_USER_SERVICES="
  evolution-addressbook-factory
  evolution-calendar-factory
  evolution-source-registry
  gamemoded.service
  goa-daemon
  goa-identity-service
  gvfs-goa-volume-monitor
  tracker-extract
  tracker-miner-fs
  tracker-miner-fs-3
  tracker-miner-rss
  tracker-store
  tracker-writeback
  ubuntu-report.path
  ubuntu-report.service
"
echo "#### Disabling user bloat services..."
for service in ${SYSTEMD_USER_SERVICES}; do
	if systemctl --user disable --now "${service}"; then
		systemctl --user mask "${service}" ||:
	fi
done

VIM_DIRS="
  "${HOME}/.vim"
  "${HOME}/.vim/autoload"
  "${HOME}/.vim/swap"
  "${HOME}/.vim/syntax"
  "${HOME}/.vim/undo"
  "${HOME}/.vim/view"
"
echo "#### Setting up vim dirs..."
for d in ${VIM_DIRS}; do
	mkdir -p "${d}"
done

if [ ! -e "${HOME}/.vim/autoload/plug.vim" ]; then
    echo "#### Installing vim-plug..."
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# echo "#### Setting stow dotfiles..."
# "${HOME}"/dotfiles/bin/.local/bin/dotfiles
