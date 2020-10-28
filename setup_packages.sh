#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

for v in "$@"; do
        if [ "$v" == "-v" ]; then
                set -o xtrace
        fi
done

PWD="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Immediately ask sudo password, keep it up for the entire exeuction
sudo -v
while true; do sudo -v; sleep 30; done &
infiloop=$!

Logger() {
	d=$(date +"%D-%T")
	msg=$(echo "$@" | sed ':a;N;$!ba;s/\n/ <nl> /g')
	echo -e "\033[1m[$d] \033\033[0m \033[0;32m $@  \033[0m "
	logger -t $0 "$msg"
}

declare -a PIP_PACKAGES=(
	'python-language-server[all]'
	"ansible"
	"ansible-lint"
	"astroid"
	"autopep8"
	"flake8"
	"flake8-awesome"
	"flake8-docstrings"
	"flake8-eradicate"
	"flake8-mypy"
	"isort"
	"jedi"
	"lazy-object-proxy"
	"lz4"
	"mccabe"
	"molecule"
	"neovim"
	"parso"
	"pluggy"
	"psutil"
	"pycodestyle"
	"pydocstyle"
	"pyflakes"
	"pykeepass"
	"pylint"
	"python-jsonrpc-server"
	"rope"
	"setuptools"
	"six"
	"snowballstemmer"
	"toml"
	"ujson"
	"wrapt"
	"yamllint"
	"yapf"
	"youtube-dl"
)

declare -a GO_PACKAGES=(
	"golang.org/x/tools/gopls"
	"github.com/go-delve/delve/cmd/dlv"
	"golang.org/x/lint/golint"
	"golang.org/x/tools/cmd/goimports"
	"golang.org/x/tools/cmd/gorename"
	"golang.org/x/tools/cmd/guru"
	"mvdan.cc/sh/cmd/shfmt"
)

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
)

declare -a ARCHIVE_PKG=(
	"cabextract"
	"lzip"
	"p7zip"
	"p7zip-plugins"
	"unzip"
)

declare -a TERM_PKG=(
	"ShellCheck"
	"ccze"
	"clang"
	"clang-tools-extra"
	"ctags"
	"ctags-etags"
	"git"
	"git-credential-libsecret"
	"golang"
	"htop"
	"make"
	"python3-devel"
	"python3-pip"
	"tmux"
	"vim"
	"vim-enhanced"
)

declare -a DESKTOP_PKG=(
	"android-tools"
	"gimp"
	"keepassxc"
	"mpv"
	"gnome-shell-extension-appindicator"
	"gnome-shell-extension-workspace-indicator"
	"syncthing"
	"telegram-desktop"
	"evolution"
	"evolution-ews"
	"https://github.com/JoseExposito/touchegg/releases/download/2.0.0/touchegg-2.0.0-1.x86_64.rpm"
)

declare -a PACKAGES_REMOVE=(
	"NetworkManager-team"
	"PackageKit"
	"PackageKit-glib"
	"abrt"
	"authselect-compat"
	"baobab"
	"brasero-libs"
	"catatonit"
	"cheese"
	"chkconfig"
	"cldr-emoji-annotation"
	"criu"
	"desktop-backgrounds-gnome"
	"device-mapper-multipath"
	"dleyna-connector-dbus"
	"dleyna-core"
	"dleyna-renderer"
	"dleyna-server"
	"dmraid-events"
	"dotconf"
	"dracut-live"
	"enchant"
	"espeak-ng"
	"fedora-chromium-config"
	"fedora-logos-httpd"
	"fedora-workstation-backgrounds"
	"fipscheck"
	"fipscheck-lib"
	"frei0r-plugins"
	"fuse-overlayfs"
	"gamemode"
	"gavl"
	"gdouros-symbola-fonts"
	"gfbgraph"
	"gnome-abrt"
	"gnome-backgrounds"
	"gnome-boxes"
	"gnome-calendar"
	"gnome-characters"
	"gnome-clocks"
	"gnome-contacts"
	"gnome-documents"
	"gnome-font-viewer"
	"gnome-getting-started-docs"
	"gnome-initial-setup"
	"gnome-logs"
	"gnome-maps"
	"gnome-music"
	"gnome-online-miners"
	"gnome-photos"
	"gnome-shell-extension-background-logo"
	"gnome-user-docs"
	"gnome-user-share"
	"gnome-video-effects"
	"gnome-weather"
	"gom"
	"grilo"
	"grilo-plugins"
	"gstreamer1-plugin-openh264"
	"httpd"
	"httpd-filesystem"
	"httpd-tools"
	"hyperv-daemons"
	"hyperv-daemons-license"
	"hypervfcopyd"
	"hypervkvpd"
	"hypervvssd"
	"ibus-hangul"
	"ibus-kkc"
	"ibus-libpinyin"
	"ibus-libzhuyin"
	"ibus-m17n"
	"ibus-qt"
	"ibus-typing-booster"
	"keybinder3"
	"kyotocabinet-libs"
	"langtable"
	"libXres"
	"libao"
	"libbsd"
	"libchamplain"
	"libchamplain-gtk"
	"libdazzle"
	"libdmapsharing"
	"libgdither"
	"libhangul"
	"libkkc"
	"libkkc-common"
	"libkkc-data"
	"liblouis"
	"libmusicbrainz5"
	"libnet"
	"libnl3-cli"
	"liboauth"
	"libpinyin"
	"libpinyin-data"
	"libreport-gtk"
	"libreport-plugin-reportuploader"
	"libteam"
	"libtimezonemap"
	"libtomcrypt"
	"libvarlink-util"
	"libwnck3"
	"libzapojit"
	"libzhuyin"
	"lldpad"
	"lrzsz"
	"lxpolkit"
	"m17n-db"
	"m17n-lib"
	"mactel-boot"
	"marisa"
	"mcelog"
	"media-player-info"
	"memtest86+"
	"mod_dnssd"
	"mod_http2"
	"oddjob"
	"oddjob-mkhomedir"
	"open-vm-tools"
	"open-vm-tools-desktop"
	"openh264"
	"openssh-askpass"
	"orca"
	"passwdqc-lib"
	"pcaudiolib"
	"pcsc-lite"
	"pinentry-gnome3"
	"python3-abrt"
	"python3-abrt-addon"
	"python3-beaker"
	"python3-beautifulsoup4"
	"python3-blivet"
	"python3-blockdev"
	"python3-brlapi"
	"python3-bytesize"
	"python3-dasbus"
	"python3-enchant"
	"python3-humanize"
	"python3-inotify"
	"python3-kickstart"
	"python3-louis"
	"python3-lxml"
	"python3-mako"
	"python3-meh"
	"python3-ntplib"
	"python3-ordered-set"
	"python3-paste"
	"python3-pid"
	"python3-productmd"
	"python3-pwquality"
	"python3-pyOpenSSL"
	"python3-pyatspi"
	"python3-pyparted"
	"python3-pyudev"
	"python3-pyxdg"
	"python3-requests-file"
	"python3-requests-ftp"
	"python3-simpleline"
	"python3-soupsieve"
	"python3-speechd"
	"python3-tempita"
	"python3-tkinter"
	"qemu-guest-agent"
	"rdist"
	"rhythmbox"
	"rpmfusion-free-appstream-data"
	"rpmfusion-nonfree-appstream-data"
	"sg3_utils-libs"
	"sgpio"
	"shotwell"
	"skkdic"
	"slirp4netns"
	"speech-dispatcher"
	"speech-dispatcher-espeak-ng"
	"spice-vdagent"
	"sushi"
	"teamd"
	"tigervnc-license"
	"tigervnc-server-minimal"
	"totem"
	"unicode-ucd"
	"unoconv"
	"usermode"
	"virtualbox-guest-additions"
	"xmlsec1-openssl"
	"yelp"
	"yelp-libs"
	"yelp-xsl"
)

declare -a MASK_SERVICES=(
	"goa-daemon.service"
	"goa-identity-service.service"
	"gvfs-goa-volume-monitor.service"
	"tracker-extract.service"
	"tracker-miner-fs.service"
	"tracker-miner-rss.service"
	"tracker-store.service"
	"tracker-writeback.service"
)

declare -a GLOBAL_VARIABLES=(
	"export MOZ_ACCELLERATED=1"
	"export MOZ_USE_XINPUT2=1"
	"export MOZ_WEBRENDER=1"
	"export MOZ_X11_EGL=1"
	"export QT_QPA_PLATFORM=xcb"
)

Logger "Add global variables..."
for line in "${GLOBAL_VARIABLES[@]}"; do
	if ! grep -q "$line" /etc/profile 2>/dev/null; then
		echo "$line" | sudo tee -a /etc/profile
	fi
done

Logger "Install rpmfusion..."
sudo dnf install -y -q "${RPMFUSION_PKG[@]}"

Logger "Install codecs..."
sudo dnf install -y -q "${CODECS_PKG[@]}"

Logger "Install archives..."
sudo dnf install -y -q "${ARCHIVE_PKG[@]}"

Logger "Install term utils, devel tools..."
sudo dnf install -y -q "${TERM_PKG[@]}"

Logger "Install desktop tools..."
sudo dnf install -y -q "${DESKTOP_PKG[@]}"

Logger "Install golang packages..."
# Install golang packages
mkdir -p ~/.local/go
for go_pkg in "${GO_PACKAGES[@]}"; do
	export GOPATH=~/.local/go;go get "$go_pkg"
done
Logger "Cleanup  golang packages src..."
rm -rf $GOPATH/src

Logger "Install python pagkages..."
pip3 -q install --no-input --no-cache --user -U "${PIP_PACKAGES[@]}" 2>/dev/null

Logger "Remove bloat services..."
for service in "${MASK_SERVICES[@]}"; do
	# add || true to allow them to fail, in case they are already masked
	systemctl --user disable --now $service 2>/dev/null || true
	systemctl --user mask $service 2>/dev/null || true
done

Logger "Remove bloat packages..."
sudo dnf remove "${PACKAGES_REMOVE[@]}" | grep -v 'No match'

kill -9 $infiloop
