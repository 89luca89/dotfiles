#!/bin/sh


# Create folders to prepare for dotfiles
mkdir -p ~/.config/keepassxc
mkdir -p ~/.config/mpv
mkdir -p ~/.config/systemd
mkdir -p ~/.config/touchegg
mkdir -p ~/.config/systemd/user
mkdir -p ~/.local/go
mkdir -p ~/.local/rust
mkdir -p ~/.vim
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/swap
mkdir -p ~/.vim/syntax
mkdir -p ~/.vim/undo
mkdir -p ~/.vim/view
mkdir -p ~/Programs

# Remove target folders
rm -f ~/.aliases
rm -f ~/.ansible.cfg
rm -f ~/.bashrc
rm -f ~/.config/keepassxc/keepassxc.ini
rm -f ~/.config/libinput-gestures.conf
rm -f ~/.config/touchegg/touchegg.conf
rm -f ~/.config/mpv/mpv.conf
rm -f ~/.ctags
rm -f ~/.gitconfig
rm -f ~/.histfile
rm -f ~/.ssh/assh.yml
rm -f ~/.tmux.conf
rm -f ~/.vimrc
rm -f ~/.zshrc

# link dotfiles
ln -sf $(pwd)/.aliases ~/.aliases
ln -sf $(pwd)/.ansible.cfg ~/.ansible.cfg
ln -sf $(pwd)/.bashrc ~/.bashrc
ln -sf $(pwd)/.ctags ~/.ctags
ln -sf $(pwd)/.tmux.conf ~/.tmux.conf
ln -sf $(pwd)/.vimrc ~/.vimrc
ln -sf $(pwd)/.zshrc ~/.zshrc
ln -sf $(pwd)/libinput-gestures.conf ~/.config/libinput-gestures.conf
ln -sf $(pwd)/mpv.conf ~/.config/mpv/mpv.conf
ln -sf $(pwd)/touchegg.conf ~/.config/touchegg/touchegg.conf
ln -sf $(pwd)/systemd/* ~/.config/systemd/
ln -sf ~/Syncthing/Conf/.gitconfig ~/.gitconfig
ln -sf ~/Syncthing/Conf/.histfile ~/.histfile
ln -sf ~/Syncthing/Conf/keepassxc.ini ~/.config/keepassxc/keepassxc.ini
ln -sf ~/Syncthing/Conf/assh.yml ~/.ssh/assh.yml

systemctl --user daemon-reload
for user_service in $(ls -1 $(pwd)/systemd/); do
    systemctl --user enable --now $user_service
done

# Srtup gnome!
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/']";
dconf reset -f /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/;
dconf load /org/gnome/desktop/wm/keybindings/ < $(pwd)/gnome-shell-keybindings.conf
dconf load /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ < $(pwd)/gnome-keybindings.conf
dconf load /org/gnome/terminal/ < $(pwd)/gnome-terminal.conf
dconf load /org/gnome/desktop/app-folders/ < $(pwd)/gnome-folders.conf
dconf write /org/gnome/mutter/experimental-features "['rt-scheduler']"
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:ctrl_modifier']"
dconf write /org/gnome/desktop/interface/cursor-blink 'false'
dconf write /org/gnome/desktop/privacy/disable-microphone 'true'
dconf write /org/gnome/desktop/privacy/recent-files-max-age '7'
dconf write /org/gnome/desktop/privacy/remove-old-temp-files 'true'
dconf write /org/gnome/desktop/privacy/disable-camera 'true'
dconf write /org/gnome/desktop/privacy/report-technical-problems 'false'
dconf write /org/gnome/desktop/privacy/remove-old-trash-files 'true'
dconf write /org/gnome/desktop/privacy/send-software-usage-stats 'false'
dconf write /org/gnome/nautilus/preferences/show-create-link 'true'
dconf write /org/gnome/nautilus/preferences/show-delete-permanently 'true'
dconf write /org/gnome/desktop/interface/show-battery-percentage 'true'
dconf write /org/gnome/nautilus/preferences/default-folder-viewer "'list-view'"
dconf write /org/gnome/nautilus/list-view/default-visible-columns "['name', 'size', 'type', 'owner', 'group', 'permissions', 'date_modified', 'starred', 'detailed_type']"
dconf write /org/gnome/desktop/wm/preferences/action-middle-click-titlebar "'minimize'"

# Vim install config
vim +PlugInstall! +qall > /dev/null 2> /dev/null
source ~/.bashrc
