#!/bin/sh

"$(dirname "$0")/bin/.local/bin/setup-dotfiles"
"$(dirname "$0")/bin/.local/bin/setup-distro"
"$(dirname "$0")/bin/.local/bin/setup-containers"
"$(dirname "$0")/bin/.local/bin/setup-flatpak"
"$(dirname "$0")/bin/.local/bin/setup-gnome"
