#!/bin/sh

if [ "$(id -ru)" -eq 0 ]
  then echo "Please run WITHOUT ROOT"
  exit
fi
set -o errexit
set -o nounset

echo "#### Adding flathub, flathub-beta..."
flatpak remote-add --user --if-not-exists flathub "https://flathub.org/repo/flathub.flatpakrepo"
flatpak remote-add --user --if-not-exists flathub-beta "https://flathub.org/beta-repo/flathub-beta.flatpakrepo"

FLATPAK_PACKAGES="
 app/org.gimp.GIMP/x86_64/stable
 com.github.jeromerobert.pdfarranger
 com.github.tchx84.Flatseal
 im.riot.Riot
 io.mpv.Mpv
 org.chromium.Chromium
 org.gnome.Boxes
 org.gnome.Calculator
 org.gnome.Calendar
 org.gnome.Characters
 org.gnome.Cheese
 org.gnome.Connections
 org.gnome.Contacts
 org.gnome.Evince
 org.gnome.FileRoller
 org.gnome.Logs
 org.gnome.Maps
 org.gnome.NautilusPreviewer
 org.gnome.NetworkDisplays
 org.gnome.Rhythmbox3
 org.gnome.Weather
 org.gnome.baobab
 org.gnome.clocks
 org.gnome.eog
 org.gnome.font-viewer
 org.gnome.gedit
 org.libreoffice.LibreOffice
 org.mozilla.Thunderbird
 org.mozilla.firefox
 org.signal.Signal
 org.telegram.desktop
 com.jgraph.drawio.desktop
 de.haeckerfelix.Fragments
 nl.hjdskes.gcolor3
 com.mattjakeman.ExtensionManager
 org.keepassxc.KeePassXC
"
echo "#### Installing base packages..."
flatpak --user install -y flathub ${FLATPAK_PACKAGES}

echo "#### Setting up firefox overrides..."
flatpak override --user --env="MOZ_ACCELLERATED=1" org.mozilla.firefox
flatpak override --user --env="MOZ_USE_XINPUT2=1" org.mozilla.firefox
flatpak override --user --env="MOZ_WEBRENDER=1" org.mozilla.firefox
flatpak override --user --env="MOZ_X11_EGL=1" org.mozilla.firefox
