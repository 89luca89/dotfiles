#!/bin/sh

ansible-playbook -i localhost, -c local -K main.yml $@
