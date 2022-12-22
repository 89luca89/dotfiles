#!/bin/sh

DIR="$(dirname $0)"
PATH=$PATH:$HOME/.local/bin

if [ ! -e /run/.containerenv ]; then
	if ! podman inspect -t container ansible > /dev/null 2>&1; then
		podman create \
			--dns 1.1.1.1 \
			--name ansible \
			--network host \
			--privileged \
			--security-opt label=disable \
			--user 0 \
			--userns keep-id \
			--volume "$HOME":"$HOME" \
			registry.fedoraproject.org/fedora sleep infinity
	fi
	podman start ansible
	podman exec -ti ansible "$(realpath $0)" $*
	podman stop -t1 ansible
	exit
fi

set -e

if ! command -v ansible || ! command -v sshpass || ! command -v ssh; then
	sudo dnf install -y ansible sshpass openssh-clients
	sudo ansible-galaxy collection install community.general -p /usr/share/ansible/collections
	sudo ansible-galaxy collection install containers.podman -p /usr/share/ansible/collections
fi

export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i localhost, --user luca-linux -kK "$DIR"/main.yml  --diff $*
