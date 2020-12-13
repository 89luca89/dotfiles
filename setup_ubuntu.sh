#!/bin/bash
# Using bash instead of posix sh, to use arrays

set -o errexit
set -o nounset
set -o pipefail

for v in "$@"; do
	if [ "$v" == "-v" ]; then
		set -o xtrace
	fi
done

PWD="$(
	cd "$(dirname "$0")" >/dev/null 2>&1
	pwd -P
)"

# Immediately ask sudo password, keep it up for the entire exeuction
sudo -v
while true; do
	sudo -v
	sleep 30
done &
infiloop=$!

clean() {
	kill -9 $infiloop
}

trap clean 1 2 15

Logger() {
	d=$(date +"%D-%T")
	msg=$(echo "$@" | sed ':a;N;$!ba;s/\n/ <nl> /g')
	printf "\033[1m[%s] \033\033[0m \033[0;32m %s  \033[0m \n" "$d" "$@"
	logger -t "$0" "$msg"
}

declare -a CODECS_PKG=(
	"ffmpeg"
	"gstreamer1.0-libav"
	"gstreamer1.0-plugins-*"
	#"gstreamer1.0-svt-av1"
	#"gstreamer1.0-svt-vp9"
	"gstreamer1.0-vaapi"
	"libva-*"
	"libvdpau-va-gl1"
	"libegl-*"
)

declare -a ARCHIVE_PKG=(
	"cabextract"
	"lzip"
	"p7zip-full"
	"unzip"
	"unrar"
)
declare -a DEV_PKG=(
	"build-essential"
	"shellcheck"
	"clang"
	"clang-tools"
	"exuberant-ctags"
	"gcc"
	"git"
	"golang"
	"lsof"
	"make"
	"python3-pip"
	"ripgrep"
	"ncdu"
)

declare -a TERM_PKG=(
	"acpi"
	"bash-completion"
	"curl"
	"flatpak"
	"libappindicator1"
	"libappindicator3-1"
	"net-tools"
	"powertop"
	"stunnel4"
	"tcpdump"
	"tlp"
	"wmctrl"
	"xclip"
	"xdotool"
	"zbar-tools"
)

cd /tmp || exit 1
wget -q -c https://github.com/JoseExposito/touchegg/releases/download/2.0.4/touchegg_2.0.4_amd64.deb
cd - || exit 1

declare -a DESKTOP_PKG=(
	"gimp"
	"libpurple-dev"
	"libreoffice-calc"
	"libreoffice-draw"
	"libreoffice-gtk3"
	"libreoffice-impress"
	"libreoffice-writer"
	"mpv"
	"network-manager-fortisslvpn-gnome"
	"network-manager-iodine-gnome"
	"network-manager-l2tp-gnome"
	"pass"
	"pass-extension-otp"
	"pidgin"
	"rsync"
	"simplescreenrecorder"
	"syncthing"
	"tmux"
	"vim"
	"ttf-mscorefonts-installer"
	"/tmp/touchegg_2.0.4_amd64.deb"
)

declare -a PACKAGES_REMOVE=(
	"evolution"
	"evolution-ews"
	"gnome-boxes"
	"gnome-calendar"
	"gnome-contacts"
	"gnome-dictionary"
	"gnome-documents"
	"gnome-getting-started-docs"
	"gnome-initial-setup"
	"gnome-maps"
	"gnome-music"
	"gnome-online-miners"
	"gnome-photos"
	"gnome-software"
	"gnome-user-docs"
	"gnome-user-share"
	"gnome-video-effects"
	"gnome-weather"
	"packagekit*"
	"snapd"
	"update-manager"
	"yelp*"
)

Logger "Update repos..."
sudo apt-get -qq update

Logger "Remove bloat packages..."
if which snap; then
	sudo snap remove snap-store
fi
sudo apt-get remove --purge "${PACKAGES_REMOVE[@]}"

Logger "Install codecs..."
sudo apt-get -qq install -y --no-install-recommends "${CODECS_PKG[@]}"

Logger "Install archives..."
sudo apt-get -qq install -y --no-install-recommends "${ARCHIVE_PKG[@]}"

Logger "Install devel tools..."
sudo apt-get -qq install -y --no-install-recommends "${DEV_PKG[@]}"

Logger "Install term utils..."
sudo apt-get -qq install -y --no-install-recommends "${TERM_PKG[@]}"

Logger "Install desktop tools..."
sudo apt-get -qq install -y --no-install-recommends "${DESKTOP_PKG[@]}"

Logger "Install gnome-shell packages..."
sudo apt-get -qq install -y --no-install-recommends \
	gnome-tweaks

Logger "Remove leftovers..."
sudo apt-get autoremove --purge

~/dotfiles/setup_distro.sh

sudo update-grub

~/dotfiles/setup_dotfiles.sh

# sudo dnf install libvirt libvirt-client virt-manager qemu-kvm qemu-user libvirt-daemon-kvm libvirt-daemon-qemu podman
