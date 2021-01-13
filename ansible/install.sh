#!/bin/sh

DIR="$(dirname $0)"

ansible-playbook -i localhost, -c local -K "$DIR"/main.yml --diff $@
