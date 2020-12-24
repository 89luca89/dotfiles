#!/bin/sh

set -o errexit
set -o nounset

#echo "[Desktop Entry]
#Name=Fix Touch
#Comment=Fix
#Exec=/home/luca-linux/bin/fix_touch.sh
#Terminal=true
#Type=Application
#Icon=system-reboot
#Categories=GTK;Utility;
#Keywords=Start again;Rotate;
#StartupNotify=true
#Hidden=true
#X-GNOME-Autostart-enabled=true
#X-GNOME-Autostart-Delay=5" | tee ~/.config/autostart/fix_touch.desktop | tee ~/.local/share/applications/fix_touch.desktop

echo "[Desktop Entry]
Name=Rotate
Comment=Rotate system
Exec=/home/luca-linux/bin/rotate.sh
Terminal=true
Type=Application
Icon=rotation-allowed-symbolic
Categories=GTK;Utility;
Keywords=Start again;Rotate;
StartupNotify=true" | tee ~/.local/share/applications/rotate.desktop

echo "[Desktop Entry]
Name=Sound Fix
Comment=fix sound system
Exec=/bin/sh -c 'killall gnome-shell
systemctl restart --user pulseaudio'
Terminal=true
Type=Application
Icon=audio-volume-high-symbolic
Categories=GTK;Utility;
StartupNotify=true" | tee ~/.local/share/applications/fix_sound.desktop

echo '[Desktop Entry]
Name=Mpv Play
Comment=play from clipboard
Exec=/home/luca-linux/bin/mpv_play
Terminal=false
Type=Application
Icon=mpv
Categories=GTK;Utility;
StartupNotify=true' | tee ~/.local/share/applications/mpv_play.desktop

gsettings set org.gnome.desktop.interface scaling-factor 1
gsettings set org.gnome.desktop.interface text-scaling-factor 1.75

sudo dnf repolist | tail -n+2 | cut -d' ' -f1 | xargs -I{} sudo dnf config-manager --set-enabled {}-testing
