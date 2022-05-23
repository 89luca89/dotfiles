#!/bin/sh

DIR="$(dirname $0)"
PATH=$PATH:$HOME/.local/bin

if command -v dnf >/dev/null; then
	PKG="dnf "
elif command -v apt >/dev/null; then
	PKG="apt"
fi

if ! command -v git >/dev/null ||
	 ! command -v sshpass >/dev/null ||
	 ! command -v ansible >/dev/null; then
	sudo $PKG install -y git ansible sshpass
fi

export ANSIBLE_HOST_KEY_CHECKING=False
# ansible-playbook -i localhost, -c local -K "$DIR"/main.yml --diff $*
ansible-playbook -i localhost, -kK "$DIR"/main.yml  --diff $*
ansible-playbook -i localhost, -c local "$DIR"/main.yml  --diff $*
