dconf load /org/gnome/terminal/legacy/profiles:/ < /home/luca-linux/Google_Drive/Dropbox/Conf/gnome-terminal/gnome-terminal-profiles

gsettings set org.gnome.Terminal.ProfilesList list "['b1dcc9dd-5262-4d8d-a863-c897e6d979b9', 'dd69adbd-856e-415c-96f1-8fc51f78c919', '45d868e8-c015-4410-a4a9-15a67ab44667']"
gsettings set org.gnome.Terminal.ProfilesList default 'b1dcc9dd-5262-4d8d-a863-c897e6d979b9'
gsettings set org.gnome.Terminal.Legacy.Settings new-terminal-mode 'tab'
gsettings set org.gnome.Terminal.Legacy.Settings tab-position 'top'
gsettings set org.gnome.Terminal.Legacy.Settings confirm-close true
gsettings set org.gnome.Terminal.Legacy.Settings shell-integration-enabled true
gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false

