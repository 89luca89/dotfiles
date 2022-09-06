#!/bin/sh

if [ "$(id -ru)" -eq 0 ]; then
	echo "Please run WITHOUT ROOT"
	exit
fi
set -o errexit
set -o nounset

systemctl --user enable --now podman-auto-update.timer
if ! podman inspect --type container syncthing > /dev/null; then
	podman create --userns keep-id --security-opt label=disable \
		--label "io.containers.autoupdate=registry" \
		--name syncthing \
		--volume ~/.config/syncthing:/var/syncthing/config \
		--volume "/home/$USER":"/home/$USER" \
		-p 127.0.0.1:8384:8384 \
		docker.io/syncthing/syncthing:latest
fi
if [ ! -e "$HOME/.config/systemd/user/podman-syncthing.service" ]; then
	podman generate systemd --restart-policy=always -t 1 syncthing > "$HOME/.config/systemd/user/podman-syncthing.service"
	systemctl --user enable --now podman-syncthing.service
fi
# 	podman run --rm -ti --userns keep-id --security-opt label=disable \
# 		--volume ~/.config/syncthing:/var/syncthing/config \
# 		--volume "$HOME":"$HOME" \
# 		-p 127.0.0.1:8384:8384 \
# 		docker.io/syncthing/syncthing:latest
