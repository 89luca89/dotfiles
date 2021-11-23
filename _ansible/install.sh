#!/bin/sh

DIR="$(dirname $0)"
PATH=$PATH:$HOME/.local/bin

base_deps="git python3"

if command -v dnf >/dev/null; then
	PKG="dnf"
elif command -v apt >/dev/null; then
	PKG="apt"
fi

if ! command -v git >/dev/null; then
	sudo $PKG install -y git
fi

if ! command -v python3 >/dev/null; then
	sudo $PKG install -y python3
fi

if ! command -v pip3 >/dev/null; then
	sudo $PKG install -y python3-pip
fi

if ! command -v ansible >/dev/null; then
	pip3 install ansible==2.9.23
fi

if groups | grep -Eq "sudo|wheel"; then
	ansible-playbook -i localhost, -c local --ask-vault-pass -K "$DIR"/main.yml --diff $*
else
	echo "Skipping some tags, user is not in sudoers"
	ansible-playbook -i localhost, -c local --ask-vault-pass \
		--skip-tags archive,archives,backports,codecs,debloat,grub,intel,virtualization,desktop_packages,flatpak_repo,powersave,rpmfusion,snapd,storage,sysctl,podman,wifi,zram \
		"$DIR"/main.yml --diff $*
fi
