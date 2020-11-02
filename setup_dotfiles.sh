#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

for v in "$@"; do
	if [ "$v" == "-v" ]; then
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
	echo -e "\033[1m[$d] \033\033[0m \033[0;32m $@  \033[0m "
	logger -t $0 "$msg"
}

Logger "Create folders to prepare for dotfiles..."
mkdir -p ~/.config/keepassxc
mkdir -p ~/.config/mpv
mkdir -p ~/.config/systemd
mkdir -p ~/.config/systemd/user
mkdir -p ~/.config/touchegg
mkdir -p ~/.local/go
mkdir -p ~/.local/rust
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
rm -f ~/.config/keepassxc/keepassxc.ini
rm -f ~/.config/libinput-gestures.conf
rm -f ~/.config/mpv/mpv.conf
rm -f ~/.config/touchegg/touchegg.conf
rm -f ~/.ctags
rm -f ~/.gitconfig
rm -f ~/.histfile
rm -f ~/.ssh/assh.yml
rm -f ~/.tmux.conf
rm -f ~/.vimrc
rm -f ~/.zshrc

Logger "Link dotfiles..."
ln -sf $PWD/.aliases ~/.aliases
ln -sf $PWD/.ansible.cfg ~/.ansible.cfg
ln -sf $PWD/.bashrc ~/.bashrc
ln -sf $PWD/.ctags ~/.ctags
ln -sf $PWD/.tmux.conf ~/.tmux.conf
ln -sf $PWD/.vimrc ~/.vimrc
ln -sf $PWD/.zshrc ~/.zshrc
ln -sf $PWD/libinput-gestures.conf ~/.config/libinput-gestures.conf
ln -sf $PWD/mpv.conf ~/.config/mpv/mpv.conf
ln -sf $PWD/systemd/* ~/.config/systemd/user/
ln -sf $PWD/touchegg.conf ~/.config/touchegg/touchegg.conf
ln -sf ~/Syncthing/Conf/.gitconfig ~/.gitconfig
ln -sf ~/Syncthing/Conf/.histfile ~/.histfile
ln -sf ~/Syncthing/Conf/keepassxc.ini ~/.config/keepassxc/keepassxc.ini
ln -sf ~/Syncthing/Conf/assh.yml ~/.ssh/assh.yml
ln -sf ~/Syncthing/Conf/dotfiles ~/

Logger "Install services..."
systemctl --user daemon-reload
for user_service in $(ls -1 $PWD/systemd/); do
	systemctl --user enable --now $user_service
done

# Srtup gnome!

Logger "Setup Keybindings..."
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/']"
dconf reset -f /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/
dconf load /org/gnome/desktop/wm/keybindings/ <$PWD/gnome-shell-keybindings.conf
dconf load /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ <$PWD/gnome-keybindings.conf

Logger "Setup gnome preferences..."
gsettings set org.gnome.nautilus.preferences always-use-location-entry true
# dconf load /org/gnome/desktop/app-folders/ <$PWD/gnome-folders.conf
dconf load /org/gnome/terminal/ <$PWD/gnome-terminal.conf
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:ctrl_modifier']"
dconf write /org/gnome/desktop/interface/cursor-blink 'false'
dconf write /org/gnome/desktop/interface/show-battery-percentage 'true'
dconf write /org/gnome/desktop/privacy/disable-camera 'true'
dconf write /org/gnome/desktop/privacy/disable-microphone 'true'
dconf write /org/gnome/desktop/privacy/recent-files-max-age '7'
dconf write /org/gnome/desktop/privacy/remove-old-temp-files 'true'
dconf write /org/gnome/desktop/privacy/remove-old-trash-files 'true'
dconf write /org/gnome/desktop/privacy/report-technical-problems 'false'
dconf write /org/gnome/desktop/privacy/send-software-usage-stats 'false'
dconf write /org/gnome/desktop/wm/preferences/action-middle-click-titlebar "'minimize'"
dconf write /org/gnome/mutter/experimental-features "['rt-scheduler']"
dconf write /org/gnome/nautilus/list-view/default-visible-columns "['name', 'size', 'type', 'owner', 'group', 'permissions', 'date_modified', 'starred', 'detailed_type']"
dconf write /org/gnome/nautilus/preferences/default-folder-viewer "'list-view'"
dconf write /org/gnome/nautilus/preferences/show-create-link 'true'
dconf write /org/gnome/nautilus/preferences/show-delete-permanently 'true'

# Restore app grid alphabetically
gsettings reset org.gnome.shell app-picker-layout || true # allow it to fail on older gnome versions

if rpm -qa | grep papirus > /dev/null; then
	Logger "Setting Icon theme..."
	gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
fi
if rpm -qa | grep arc-theme > /dev/null; then
	Logger "Setting GTK theme..."
	gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark-solid"
fi

Logger "Setup Vim..."
curl -fsLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -E +PlugInstall! +qall 2>/dev/null
gnome-terminal -- tmux "uname -a" 2>/dev/null || true
