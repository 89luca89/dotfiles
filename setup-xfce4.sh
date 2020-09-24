xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -s 2
xfconf-query -c xsettings -p /Net/ThemeName -s 'Arc-Dark'
xfconf-query -c xsettings -p /Net/IconThemeName -s 'Papirus-Dark'
xfconf-query -c xfce4-panel -p /panels/panel-2 -rR
xfconf-query -c xfce4-panel -p /panels/panel-1/position -s "p=8;x=960;y=1200"

xfconf-query -c xfce4-panel -p /plugins/plugin-1 -s whiskermenu

plugin_tasklist=$(xfconf-query -c xfce4-panel -p /plugins -lv | grep tasklist | cut -d' ' -f1)
xfconf-query -c xfce4-panel -p $plugin_tasklist/flat-buttons -s true
xfconf-query -c xfce4-panel -p $plugin_tasklist/grouping -s 1
xfconf-query -c xfce4-panel -p $plugin_tasklist/show-handle -s true
xfconf-query -c xfce4-panel -p $plugin_tasklist/show-labels -s false
xfconf-query -c xfce4-panel -p $plugin_tasklist/show-wireframes -s false
xfconf-query -c xfce4-panel -p $plugin_tasklist/switch-workspace-on-unminimize -s true

plugin_actions=$(xfconf-query -c xfce4-panel -p /plugins -lv | grep actions | cut -d' ' -f1)
xfconf-query -c xfce4-panel -p $plugin_actions -rR

plugin_workspace=$(xfconf-query -c xfce4-panel -p /plugins -lv | grep windowmenu | cut -d' ' -f1)
xfconf-query -c xfce4-panel -p $plugin_workspace/plugin-9/style -s 1
xfconf-query -c xfce4-panel -p $plugin_workspace/plugin-9/workspace-actions -s true

xfce4-panel -r
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/Super_L /usr/bin/xfce4-popup-whiskermenu
sudo dnf remove xfce4-terminal xfce4-taskmanager thunar*
sudo dnf install nautilus gnome-terminal evince evolution evolution-ews file-roller marker gnome-screenshot mpv gnome-system-monitor
# sudo dnf install xfdashboard
echo "keyboard=onboard -t Droid -l Compact -e
keyboard-position = 50%,center -0;100% 25%" | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf
