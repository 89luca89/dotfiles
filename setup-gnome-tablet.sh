sudo dnf install -y onboard gnome-extensions-app gnome-tweaks

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
Icon=system-reboot
Categories=GTK;Utility;
Keywords=Start again;Rotate;
StartupNotify=true' | tee ~/.local/share/applications/rotate.desktop

pushd ~/Syncthing/Conf
for ext in *extension.zip; do
    gnome-extensions install $ext --force
done
popd
