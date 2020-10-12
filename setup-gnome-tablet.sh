sudo usermod -aG luca-linux gdm
sudo chmod 0755 /var/lib/gdm/.config/
sudo chmod g+w /var/lib/gdm/.config/
sudo chmod g+w /var/lib/gdm/.config/monitors.xml

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
    onboard

echo '[Desktop Entry]
Name=Fix Touch
Comment=Fix
Exec=/home/luca-linux/bin/fix_touch.sh
Terminal=true
Type=Application
Icon=system-reboot
Categories=GTK;Utility;
Keywords=Start again;Rotate;
StartupNotify=true
Hidden=true
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=5' | tee ~/.config/autostart/fix_touch.desktop | tee ~/.local/share/applications/fix_touch.desktop

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

echo '[Desktop Entry]
Name=Sound Fix
Comment=fix sound system
Exec=/bin/sh -c 'killall gnome-shell; systemctl restart --user pulseaudio'
Terminal=true
Type=Application
Icon=audio-volume-high-symbolic
Categories=GTK;Utility;
StartupNotify=true' | tee ~/.local/share/applications/fix_sound.desktop

echo 'Section "Device"
  Identifier "Intel Graphics"
  Driver "intel"

  Option "TearFree" "true"
EndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf

echo '[Desktop Entry]
Name=Mpv Play
Comment=play from clipboard
Exec=/home/luca-linux/bin/mpv_play
Terminal=false
Type=Application
Icon=/home/luca-linux/Syncthing/Conf/Shortcuts/applications/video-play.png
Categories=GTK;Utility;
StartupNotify=true'  | tee ~/.local/share/applications/fix_sound.desktop

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
gsettings set org.onboard.keyboard touch-feedback-size 100

gsettings set org.gnome.desktop.lockdown disable-lock-screen true
gsettings set org.gnome.desktop.interface text-scaling-factor 1.5
gsettings set org.gnome.mutter experimental-features "['x11-randr-fractional-scaling']"

echo '<monitors version="2">
  <configuration>
    <logicalmonitor>
      <x>0</x>
      <y>0</y>
      <scale>2</scale>
      <primary>yes</primary>
      <transform>
        <rotation>right</rotation>
        <flipped>no</flipped>
      </transform>
      <monitor>
        <monitorspec>
          <connector>DSI-1</connector>
          <vendor>unknown</vendor>
          <product>unknown</product>
          <serial>unknown</serial>
        </monitorspec>
        <mode>
          <width>1200</width>
          <height>1920</height>
          <rate>60.023551940917969</rate>
        </mode>
      </monitor>
    </logicalmonitor>
  </configuration>
</monitors>' | sudo tee /var/lib/gdm/.config/monitors.xml
