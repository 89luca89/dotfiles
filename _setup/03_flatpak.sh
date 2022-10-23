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
	com.github.jeromerobert.pdfarranger
	com.github.tchx84.Flatseal
	com.jgraph.drawio.desktop
	com.mattjakeman.ExtensionManager
	com.obsproject.Studio
	com.slack.Slack
	im.riot.Riot
	io.mpv.Mpv
	net.pcsx2.PCSX2
	nl.hjdskes.gcolor3
	org.chromium.Chromium
	org.gimp.GIMP
	org.gnome.Calculator
	org.gnome.Calendar
	org.gnome.Cheese
	org.gnome.Connections
	org.gnome.Evince
	org.gnome.FileRoller
	org.gnome.NautilusPreviewer
	org.gnome.NetworkDisplays
	org.gnome.Rhythmbox3
	org.gnome.eog
	org.gnome.TextEditor
	org.gnome.gitlab.somas.Apostrophe
	org.gnome.seahorse.Application
	org.keepassxc.KeePassXC
	org.libreoffice.LibreOffice
	org.mozilla.Thunderbird
	org.mozilla.firefox
	org.telegram.desktop
"
echo "#### Installing base packages..."
flatpak --user install -y flathub ${FLATPAK_PACKAGES}


# flatpak override --user --env="MOZ_ACCELLERATED=1" org.mozilla.firefox
flatpak override --user --env="MOZ_USE_XINPUT2=1" org.mozilla.firefox
flatpak override --user --env="MOZ_ENABLE_WAYLAND=1" org.mozilla.firefox
# flatpak override --user --env="MOZ_WEBRENDER=1" org.mozilla.firefox
# flatpak override --user --env="MOZ_X11_EGL=1" org.mozilla.firefox
