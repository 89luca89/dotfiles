#!/bin/bash
# Using bash instead of posix sh, to use arrays

set -o errexit
set -o nounset
set -o pipefail

for v in "$@"; do
	if [ "$v" = "-v" ]; then
		set -o xtrace
	fi
done

PWD="$(
	cd "$(dirname "$0")" >/dev/null 2>&1
	pwd -P
)"

Logger() {
	d=$(date +"%D-%T")
	msg=$(echo "$@" | sed ':a;N;$!ba;s/\n/ <nl> /g')
	printf "\033[1m[%s] \033\033[0m \033[0;32m %s  \033[0m \n" "$d" "$@"
	logger -t "$0" "$msg"
}

Logger "Create folders to prepare for dotfiles..."
mkdir -p ~/.config/mpv
mkdir -p ~/.config/systemd
mkdir -p ~/.config/systemd/user
mkdir -p ~/.config/touchegg
mkdir -p ~/.local/go
mkdir -p ~/.local/rust
mkdir -p ~/.local/share
mkdir -p ~/.ssh/
mkdir -p ~/.vim
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/swap
mkdir -p ~/.vim/syntax
mkdir -p ~/.vim/undo
mkdir -p ~/.vim/view
mkdir -p ~/Programs

Logger "Remove target folders..."
rm -f ~/.aliases
rm -f ~/.ansible.cfg
rm -f ~/.bashrc
rm -f ~/.config/kitty
rm -f ~/.config/mpv/mpv.conf
rm -f ~/.config/touchegg/touchegg.conf
rm -f ~/.ctags
rm -f ~/.gitconfig
rm -f ~/.histfile
rm -f ~/.ssh/assh.yml
rm -f ~/.tmux.conf
rm -f ~/.vimrc
rm -f ~/.zshrc
rm -rf ~/.local/share/applications

Logger "Link dotfiles..."
ln -sf "$PWD"/.aliases ~/.aliases
ln -sf "$PWD"/.ansible.cfg ~/.ansible.cfg
ln -sf "$PWD"/.bashrc ~/.bashrc
ln -sf "$PWD"/.ctags ~/.ctags
ln -sf "$PWD"/.tmux.conf ~/.tmux.conf
ln -sf "$PWD"/.toprc ~/.toprc
ln -sf "$PWD"/.vimrc ~/.vimrc
ln -sf "$PWD"/.zshrc ~/.zshrc
ln -sf "$PWD"/assh.yml ~/.ssh/assh.yml
ln -sf "$PWD"/kitty ~/.config/kitty
ln -sf "$PWD"/mpv.conf ~/.config/mpv/mpv.conf
ln -sf "$PWD"/systemd/* ~/.config/systemd/user/
ln -sf "$PWD"/touchegg.conf ~/.config/touchegg/touchegg.conf
ln -sf "$PWD"/applications ~/.local/share/applications

# Symlink also stuff from syncthing
if [ -d ~/Syncthing ]; then
	ln -sf ~/Syncthing/Conf/.gitconfig ~/.gitconfig
	ln -sf ~/Syncthing/Conf/.histfile ~/.histfile
	[ ! -d ~/dotfiles ] && ln -sf ~/Syncthing/Conf/dotfiles ~/
fi

Logger "Install services..."
systemctl --user daemon-reload
for user_service in $(ls -1 "$PWD"/systemd/); do
	systemctl --user enable --now "$user_service"
done

declare -a MASK_SERVICES=(
	"evolution-addressbook-factory.service"
	"evolution-calendar-factory.service"
	"evolution-source-registry.service"
	"goa-daemon.service"
	"goa-identity-service.service"
	"gvfs-goa-volume-monitor.service"
	"tracker-extract.service"
	"tracker-miner-fs.service"
	"tracker-miner-fs-3.service"
	"tracker-miner-rss.service"
	"tracker-store.service"
	"tracker-writeback.service"
)

Logger "Remove bloat services..."
for service in "${MASK_SERVICES[@]}"; do
	# add || true to allow them to fail, in case they are already masked
	systemctl --user disable --now "$service" 2>/dev/null || true
	systemctl --user mask "$service" 2>/dev/null || true
done

Logger "Setup gnome preferences..."
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:ctrl_modifier']"
dconf write /org/gnome/desktop/interface/cursor-blink 'false'
dconf write /org/gnome/desktop/interface/show-battery-percentage 'true'
dconf write /org/gnome/desktop/peripherals/mouse/accel-profile "'adaptive'"
dconf write /org/gnome/desktop/peripherals/touchpad/natural-scroll 'true'
dconf write /org/gnome/desktop/peripherals/touchpad/tap-to-click 'true'
dconf write /org/gnome/desktop/peripherals/touchpad/two-finger-scrolling-enabled 'true'
dconf write /org/gnome/desktop/privacy/disable-camera 'true'
dconf write /org/gnome/desktop/privacy/disable-microphone 'true'
dconf write /org/gnome/desktop/privacy/recent-files-max-age '7'
dconf write /org/gnome/desktop/privacy/remove-old-temp-files 'true'
dconf write /org/gnome/desktop/privacy/remove-old-trash-files 'true'
dconf write /org/gnome/desktop/privacy/report-technical-problems 'false'
dconf write /org/gnome/desktop/privacy/send-software-usage-stats 'false'
dconf write /org/gnome/desktop/wm/preferences/action-middle-click-titlebar "'minimize'"
dconf write /org/gnome/desktop/wm/preferences/button-layout "':close'"
dconf write /org/gnome/mutter/center-new-windows 'true'
dconf write /org/gnome/mutter/experimental-features "['rt-scheduler']"
dconf write /org/gnome/nautilus/list-view/use-tree-view 'true'
dconf write /org/gnome/nautilus/preferences/always-use-location-entry 'true'
dconf write /org/gnome/nautilus/preferences/show-delete-permanently 'true'
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type "'nothing'"
dconf write /org/gnome/shell/overrides/workspaces-only-on-primary 'true'
dconf write /org/gtk/settings/file-chooser/sort-directories-first 'true'
dconf write /org/freedesktop/tracker/miner/files/index-on-battery 'false'
# Restore app grid alphabetically
gsettings reset org.gnome.shell app-picker-layout || true # allow it to fail on older gnome versions

Logger "Setup Vim..."
curl -fsLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -E +PlugInstall! +qall 2>/dev/null
gnome-terminal -- tmux "uname -a" 2>/dev/null || true

Logger "DONE"
