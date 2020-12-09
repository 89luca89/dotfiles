#!/bin/bash
# Using bash instead of posix sh, to use arrays

# nvidia: sudo dnf install kmod-nvidia akmod-nvidia xorg-x11-drv-nvidia nvidia-settings nvidia-modprobe nvidia-xconfig
# sudo cp /usr/share/X11/xorg.conf.d/nvidia.conf /etc/X11/xorg.conf.d/
# sudo sed -i '/^EndSection/i \\tOption "PrimaryGPU" "yes"' /etc/X11/xorg.conf.d/nvidia.conf

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

declare -a RPMFUSION_PKG=(
	"https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
	"https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
)

declare -a CODECS_PKG=(
	"compat-ffmpeg28"
	"compat-ffmpeg28-devel"
	"ffmpeg"
	"ffmpeg-libs"
	"gstreamer1-libav"
	"gstreamer1-plugins-bad-free"
	"gstreamer1-plugins-bad-freeworld"
	"gstreamer1-plugins-base"
	"gstreamer1-plugins-base-tools"
	"gstreamer1-plugins-good"
	"gstreamer1-plugins-good-extras"
	"gstreamer1-plugins-ugly"
	"gstreamer1-plugins-ugly-free"
	"gstreamer1-svt-av1"
	"gstreamer1-svt-vp9"
	"gstreamer1-vaapi"
	"intel-media-driver"
	"libva-devel"
	"libva-intel-driver"
	"libva-intel-hybrid-driver"
	"libva-utils"
	"libva-vdpau-driver"
	"libvdpau-va-gl"
	"egl-utils"
	"egl-wayland"
)

declare -a ARCHIVE_PKG=(
	"cabextract"
	"lzip"
	"p7zip"
	"p7zip-plugins"
	"unzip"
	"unrar"
)
declare -a DEV_PKG=(
	"ShellCheck"
	"android-tools"
	"clang"
	"clang-tools-extra"
	"ctags"
	"ctags-etags"
	"git"
	"git-credential-libsecret"
	"golang"
	"lsof"
	"make"
	"python3-pip"
	"ripgrep"
	"ncdu"
)

declare -a TERM_PKG=(
	"NetworkManager-tui"
	"acpi"
	"bash-completion"
	"flatpak"
	"htop"
	"libappindicator"
	"libappindicator-gtk3"
	"net-tools"
	"powertop"
	"stunnel"
	"tcpdump"
	"tlp"
	"wmctrl"
	"xclip"
	"xdotool"
	"zbar"
)

declare -a DESKTOP_PKG=(
	"NetworkManager-fortisslvpn-gnome"
	"NetworkManager-iodine-gnome"
	"NetworkManager-l2tp-gnome"
	"NetworkManager-libreswan-gnome"
	"NetworkManager-sstp-gnome"
	"NetworkManager-strongswan-gnome"
	"gimp"
	"kitty"
	"libpurple-devel"
	"libreoffice-calc"
	"libreoffice-draw"
	"libreoffice-gtk3"
	"libreoffice-impress"
	"libreoffice-writer"
	"mpv"
	"papirus-icon-theme"
	"pass"
	"pass-otp"
	"pass-pwned"
	"pidgin"
	"pidgin-libnotify"
	"pidgin-window-merge"
	"purple-plugin_pack"
	"purple-plugin_pack-pidgin"
	"purple-plugin_pack-pidgin-xmms"
	"purple-skypeweb"
	"purple-telegram"
	"rsync"
	"simplescreenrecorder"
	"syncthing"
	"tmux"
	"vim"
	"vim-X11"
	"vim-enhanced"
	"https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm"
	"https://github.com/JoseExposito/touchegg/releases/download/2.0.0/touchegg-2.0.0-1.x86_64.rpm"
)

declare -a PACKAGES_REMOVE=(
	"*abrt*"
	"PackageKit"
	"PackageKit-glib"
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
	"httpd"
	"setroubleshoot*"
	"tracker"
	"tracker-miners"
)

declare -a DNF_FLAGS=(
	"deltarpm=true"
	"fastestmirror=true"
	"max_parallel_downloads=6"
)

Logger "Add dnf flags..."
for line in "${DNF_FLAGS[@]}"; do
	if ! grep -q "$line" /etc/dnf/dnf.conf 2>/dev/null; then
		echo "$line" | sudo tee -a /etc/dnf/dnf.conf
	fi
done

# Logger "Remove bloat packages..."
sudo dnf remove "${PACKAGES_REMOVE[@]}"

Logger "Install rpmfusion..."
sudo dnf --setopt=install_weak_deps=False --best install -y -q "${RPMFUSION_PKG[@]}"

Logger "Install codecs..."
sudo dnf --setopt=install_weak_deps=False --best install -y -q "${CODECS_PKG[@]}"

Logger "Install archives..."
sudo dnf --setopt=install_weak_deps=False --best install -y -q "${ARCHIVE_PKG[@]}"

Logger "Install devel tools..."
sudo dnf --setopt=install_weak_deps=False --best install -y -q "${DEV_PKG[@]}"

Logger "Install term utils..."
sudo dnf --setopt=install_weak_deps=False --best install -y -q "${TERM_PKG[@]}"

Logger "Install desktop tools..."
sudo dnf --setopt=install_weak_deps=False --best install -y -q "${DESKTOP_PKG[@]}"

if rpm -qa | grep papirus >/dev/null; then
	Logger "Install gnome-shell packages..."
	sudo dnf --setopt=install_weak_deps=False --best install -y -q \
		gnome-shell-extension-topicons-plus \
		gnome-shell-extension-workspace-indicator \
		gnome-tweaks
fi
# sudo dnf install libvirt libvirt-client virt-manager qemu-kvm qemu-user libvirt-daemon-kvm libvirt-daemon-qemu podman

~/dotfiles/setup_dotfiles.sh
