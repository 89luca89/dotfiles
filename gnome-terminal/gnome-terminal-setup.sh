dconf load /org/gnome/terminal/legacy/profiles:/ < ~/dotfiles/gnome-terminal/gnome-terminal-profiles

gsettings set org.gnome.Terminal.ProfilesList list "['b1dcc9dd-5262-4d8d-a863-c897e6d979b9', '5ceb187c-9775-421c-80c9-96d949e5bff3', '4086292e-8f46-4425-b4e5-9754922925fe']"
gsettings set org.gnome.Terminal.ProfilesList default 'b1dcc9dd-5262-4d8d-a863-c897e6d979b9'
gsettings set org.gnome.Terminal.Legacy.Settings new-terminal-mode 'tab'
gsettings set org.gnome.Terminal.Legacy.Settings tab-position 'top'
gsettings set org.gnome.Terminal.Legacy.Settings confirm-close true
gsettings set org.gnome.Terminal.Legacy.Settings shell-integration-enabled true
gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false

