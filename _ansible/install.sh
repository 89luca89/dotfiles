#!/bin/sh


DIR="$(dirname $0)"
PATH=$PATH:$HOME/.local/bin

if [ ! -e /run/.containerenv ]; then
	if ! podman inspect -t container ansible > /dev/null; then
		podman create \
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
	podman exec -ti ansible "$(realpath $0)"
	podman stop ansible
	exit
fi

set -e

dnf install -y git ansible sshpass openssh-clients
ansible-galaxy collection install community.general -p /usr/share/ansible/collections
ansible-galaxy collection install containers.podman -p /usr/share/ansible/collections

export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i localhost, --user luca-linux -kK "$DIR"/main.yml  --diff $*
