#!/bin/sh

DIR="$(dirname $0)"
PATH=$PATH:$HOME/.local/bin

base_deps="git python3"

if command -v dnf >/dev/null; then
	PKG="dnf "
elif command -v apt >/dev/null; then
	PKG="apt"
fi

if ! command -v git >/dev/null; then
	sudo $PKG install -y git
fi

if ! command -v ansible >/dev/null; then
	sudo $PKG install -y ansible
fi

ansible-playbook -i localhost, -c local --ask-vault-pass -K "$DIR"/main.yml --diff $*
