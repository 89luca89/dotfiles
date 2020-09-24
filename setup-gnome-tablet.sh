sudo dnf install -y \
    cheese \
    geary \
    gnome-calendar \
    gnome-clocks \
    gnome-contacts \
    gnome-extensions-app \
    gnome-music \
    gnome-tweaks \
    gnome-weather \
    marker \
    onboard \
    totem

echo '[Desktop Entry]
Name=Fix Touch
Comment=Fix
Exec=sh -c "sleep 5s && xdotool key Alt+F2 && sleep 1 && xdotool key r && xdotool key Return"
Terminal=true
Type=Application
Icon=system-reboot
Categories=GTK;Utility;
Keywords=Start again;Rotate;
StartupNotify=true
Hidden=true
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=10' | tee ~/.config/autostart/fix_touch.desktop | tee ~/.local/share/applications/fix_touch.desktop

echo '[Desktop Entry]
Name=Rotate
Comment=Rotate system
Exec=/home/luca-linux/bin/rotate.sh
Terminal=true
Type=Application
Icon=rotation-allowed-symbolic
Categories=GTK;Utility;
Keywords=Start again;Rotate;
StartupNotify=true' | tee ~/.local/share/applications/rotate.desktop

echo 'Section "Device"
  Identifier "Intel Graphics"
  Driver "intel"

  Option "TearFree" "true"
EndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf

pushd ~/Syncthing/Conf
for ext in *extension.zip; do
	gnome-extensions install $ext --force
done
popd

gsettings set org.onboard theme '/usr/share/onboard/themes/Droid.theme'
gsettings set org.onboard layout '/usr/share/onboard/layouts/Compact.onboard' #Phone.onboard
gsettings set org.onboard.auto-show enabled true
gsettings set org.onboard.keyboard audio-feedback-enabled true
gsettings set org.onboard.keyboard touch-feedback-enabled true
gsettings set org.onboard.window docking-enabled true
