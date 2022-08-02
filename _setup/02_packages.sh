#!/bin/sh

if [ "$(id -ru)" -ne 0 ]; then
	echo "Please run as root"
	exit
fi
set -o errexit
set -o nounset

echo "#### Removing unused system flatpaks..."
flatpak uninstall --all
flatpak remote-delete fedora || :

echo "#### Setting up distro packages..."
if command -v rpm-ostree > /dev/null; then
	rpm-ostree override remove gnome-software gnome-software-rpm-ostree
	for i in $(grep GRUB_CMDLINE_LINUX /etc/default/grub | grep -Eo "rhgb quiet.*" | cut -d' ' -f3- | tr -d '"'); do
		rpm-ostree kargs --append-if-missing=$i
	done
elif command -v tukit > /dev/null; then
	tukit --discard --continue execute bash -c "
	zypper addlock yast2;
	zypper rm -y gnome-software;
	find /boot -name "grub.cfg" | xargs -I{} grub2-mkconfig -o {};
        dracut --force --regenerate-all;
    "
fi
