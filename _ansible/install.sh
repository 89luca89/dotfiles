#!/bin/sh

DIR="$(dirname $0)"

base_deps="git python3 ansible"

if command -v dnf >/dev/null; then
	PKG="dnf"
elif command -v apt >/dev/null; then
	PKG="apt"
fi

for i in $base_deps; do
	if ! command -v "$i" >/dev/null; then
		sudo $PKG install -y "$i"
	fi
done

ansible-playbook -i localhost, -c local --ask-vault-pass -K "$DIR"/main.yml --diff $*
