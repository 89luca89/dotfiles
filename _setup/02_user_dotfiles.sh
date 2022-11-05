#!/bin/sh

if [ "$(id -ru)" -eq 0 ]; then
	echo   "Please run WITHOUT ROOT"
	exit
fi
set -o errexit
set -o nounset

SYSTEMD_USER_SERVICES="
  evolution-addressbook-factory.service
  evolution-calendar-factory.service
  evolution-source-registry.service
  evolution-user-prompter.service
  gamemoded.service.service
  gvfs-goa-volume-monitor.service
  tracker-extract-3.service
  tracker-miner-fs-3.service
  tracker-miner-fs-control-3.service
  tracker-miner-rss-3.service
  tracker-writeback-3.service
  tracker-xdg-portal-3.service
"
echo "#### Disabling user bloat services..."
for service in ${SYSTEMD_USER_SERVICES}; do
	systemctl --user disable --now "${service}" || :
	systemctl --user mask "${service}" || :
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
"${HOME}"/dotfiles/bin/.local/bin/dotfiles
