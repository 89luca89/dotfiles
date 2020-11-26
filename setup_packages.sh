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

declare -a PIP_PACKAGES=(
	'python-language-server[all]'
	"ansible"
	"ansible-later"
	"ansible-lint"
	"astroid"
	"autopep8"
	"demjson"
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
	"pass-import"
	"pluggy"
	"psutil"
	"pycodestyle"
	"pydocstyle"
	"pyflakes"
	"pylint"
	"python-jsonrpc-server"
	"rope"
	"setuptools"
	"six"
	"snowballstemmer"
	"toml"
	"ujson"
	"upass"
	"wrapt"
	"yamllint"
	"yapf"
	"youtube-dl"
)

declare -a GO_PACKAGES=(
	"github.com/go-delve/delve/cmd/dlv"
	"golang.org/x/lint/golint"
	"golang.org/x/tools/cmd/goimports"
	"golang.org/x/tools/cmd/gorename"
	"golang.org/x/tools/cmd/guru"
	"golang.org/x/tools/gopls"
	"mvdan.cc/sh/cmd/shfmt"
	"mvdan.cc/gofumpt/gofumports"
	"mvdan.cc/gofumpt"
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
	"NetworkManager-tui"
	"ShellCheck"
	"android-tools"
	"ccze"
	"clang"
	"clang-tools-extra"
	"ctags"
	"ctags-etags"
	"flatpak"
	"git"
	"git-credential-libsecret"
	"golang"
	"htop"
	"make"
	"nodejs"
	"npm"
	"pass"
	"pass-otp"
	"pass-pwned"
	"powertop"
	"python3-devel"
	"python3-pip"
	"ripgrep"
	"rsync"
	"stunnel"
	"tlp"
	"tmux"
	"vim"
	"vim-X11"
	"vim-enhanced"
	"wmctrl"
	"xclip"
	"xdotool"
	"zbar"
)

declare -a DESKTOP_PKG=(
	"arc-theme"
	"baobab"
	"eog"
	"evince"
	"file-roller"
	"gedit"
	"gimp"
	"gnome-calculator"
	"gnome-disk-utility"
	"gnome-system-monitor"
	"libreoffice-calc"
	"libreoffice-draw"
	"libreoffice-impress"
	"libreoffice-writer"
	"mpv"
	"papirus-icon-theme"
	"rhythmbox"
	"simplescreenrecorder"
	"syncthing"
	"telegram-desktop"
	"thunderbird"
	"virt-manager"
	"https://github.com/JoseExposito/touchegg/releases/download/2.0.0/touchegg-2.0.0-1.x86_64.rpm"
)

declare -a PACKAGES_REMOVE=(
	"NetworkManager-team"
	"PackageKit"
	"PackageKit-glib"
	"abrt"
	"authselect-compat"
	"catatonit"
	"cheese"
	"chkconfig"
	"cldr-emoji-annotation"
	"criu"
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
	"fipscheck"
	"fipscheck-lib"
	"frei0r-plugins"
	"fuse-overlayfs"
	"gamemode"
	"gavl"
	"gdouros-symbola-fonts"
	"gfbgraph"
	"gnome-abrt"
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
	"gnome-software"
	"gnome-user-docs"
	"gnome-user-share"
	"gnome-video-effects"
	"gnome-weather"
	"gom"
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
	"kyotocabinet-libs"
	"langtable"
	"libao"
	"libbsd"
	"libchamplain"
	"libchamplain-gtk"
	"libdazzle"
	"libhangul"
	"libkkc"
	"libkkc-common"
	"libkkc-data"
	"liblouis"
	"libmusicbrainz5"
	"libnet"
	"libnl3-cli"
	"libpinyin"
	"libpinyin-data"
	"libreport-gtk"
	"libreport-plugin-reportuploader"
	"libteam"
	"libtimezonemap"
	"libvarlink-util"
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
	"memtest86+"
	"mod_dnssd"
	"mod_http2"
	"oddjob"
	"oddjob-mkhomedir"
	"open-vm-tools"
	"open-vm-tools-desktop"
	"openh264"
	"orca"
	"passwdqc-lib"
	"pcaudiolib"
	"pcsc-lite"
	"pinentry-gnome3"
	"python3-abrt"
	"python3-abrt-addon"
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
	"python3-meh"
	"python3-ntplib"
	"python3-ordered-set"
	"python3-pid"
	"python3-productmd"
	"python3-pwquality"
	"python3-pyatspi"
	"python3-pyparted"
	"python3-pyudev"
	"python3-pyxdg"
	"python3-requests-file"
	"python3-requests-ftp"
	"python3-simpleline"
	"python3-soupsieve"
	"python3-speechd"
	"python3-tkinter"
	"qemu-guest-agent"
	"rdist"
	"rpmfusion-free-appstream-data"
	"rpmfusion-nonfree-appstream-data"
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
	"virtualbox-guest-additions"
	"xmlsec1-openssl"
	"yelp"
	"yelp-libs"
	"yelp-xsl"
)

declare -a MASK_SERVICES=(
	"evolution-addressbook-factory.service"
	"evolution-calendar-factory.service"
	"evolution-source-registry.service"
	"goa-daemon.service"
	"goa-identity-service.service"
	"gvfs-goa-volume-monitor.service"
	"tracker-extract.service"
	"tracker-miner-fs.service"
	"tracker-miner-fs-3.service"
	"tracker-miner-rss.service"
	"tracker-store.service"
	"tracker-writeback.service"
)

declare -a SYSCTL_FLAGS=(
	"fs.inotify.max_user_watches=524288"
	"vm.block_dump=1"
	"vm.dirty_background_ratio=50"
	"vm.dirty_expire_centisecs=60000"
	"vm.dirty_ratio=90"
	"vm.dirty_writeback_centisecs=60000"
	"vm.laptop_mode=5"
	"vm.oom_kill_allocating_task=1"
	"vm.swappiness=5"
	"vm.vfs_cache_pressure=100"
)

declare -a GLOBAL_VARIABLES=(
	"export MOZ_ACCELLERATED=1"
	"export MOZ_USE_XINPUT2=1"
	"export MOZ_WEBRENDER=1"
	"export MOZ_X11_EGL=1"
	"export QT_QPA_PLATFORM=xcb"
)

declare -a DNF_FLAGS=(
	"deltarpm=true"
	"fastestmirror=true"
	"max_parallel_downloads=6"
)

Logger "Add global variables..."
for line in "${GLOBAL_VARIABLES[@]}"; do
	if ! grep -q "$line" /etc/profile 2>/dev/null; then
		echo "$line" | sudo tee -a /etc/profile
	fi
done

Logger "Add dnf flags..."
for line in "${DNF_FLAGS[@]}"; do
	if ! grep -q "$line" /etc/dnf/dnf.conf 2>/dev/null; then
		echo "$line" | sudo tee -a /etc/dnf/dnf.conf
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

Logger "Install flathub..."
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

Logger "Install golang packages..."
# Install golang packages
export GOPATH=~/.local/go
mkdir -p "$GOPATH"
for go_pkg in "${GO_PACKAGES[@]}"; do
	bin_name=$(echo "$go_pkg" | rev | cut -d'/' -f1 | rev)
	if [ ! -f "$GOPATH"/bin/"$bin_name" ]; then
		go get "$go_pkg"
	fi
done
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$GOPATH"/bin v1.32.2
Logger "Cleanup  golang packages src..."
rm -rf $GOPATH/src

Logger "Install npm packages..."
# Install golang packages
mkdir -p ~/.local/bin/node_modules
for npm_pkg in "${NPM_PACKAGES[@]}"; do
	if [ ! -f ~/.local/bin/node_modules/.bin/"$npm_pkg" ]; then
		pushd ~/.local/bin/
		npm install --production "$npm_pkg"
		popd
	fi
done

Logger "Install python pagkages..."
/usr/bin/python3 -m pip install --no-input --no-cache --user -U pip
/usr/bin/python3 -m pip -q install --no-input --no-cache --user -U "${PIP_PACKAGES[@]}"

TERRAFORM_VERSION=0.12.0
TERRAFORM_LS_VERSION=0.8.0
TERRAFORM_PROVIDER_VERSION=0.6.2
TERRAFORM_PROVIDER_RELEASE=0.6.2+git.1585292411.8cbe9ad0

if ! command -v terraform 2>/dev/null; then
	curl -sLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/"$TERRAFORM_VERSION"/terraform_"$TERRAFORM_VERSION"_linux_amd64.zip
	unzip /tmp/terraform.zip -d /tmp
	mv /tmp/terraform ~/.local/bin
fi

if ! command -v terraform-ls 2>/dev/null; then
	curl -sLo /tmp/terraform-ls.zip https://releases.hashicorp.com/terraform-ls/"$TERRAFORM_LS_VERSION"/terraform-ls_"$TERRAFORM_LS_VERSION"_linux_amd64.zip
	unzip /tmp/terraform-ls.zip -d /tmp
	mv /tmp/terraform-ls ~/.local/bin
fi

# Install Terraform Provider for Libvirt 0.6.2
if [ ! -f ~/.terraform.d/plugins/linux_amd64/terraform-provider-libvirt ]; then
	mkdir -p ~/.terraform.d/plugins/linux_amd64
	curl -sLo /tmp/terraform-provider-libvirt.tar.gz https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v"$TERRAFORM_PROVIDER_VERSION"/terraform-provider-libvirt-"$TERRAFORM_PROVIDER_RELEASE".Ubuntu_18.04.amd64.tar.gz
	tar zxvf /tmp/terraform-provider-libvirt.tar.gz
	mv terraform-provider-libvirt ~/.terraform.d/plugins/linux_amd64/
	~/.terraform.d/plugins/linux_amd64/terraform-provider-libvirt -version
fi

Logger "Remove bloat services..."
for service in "${MASK_SERVICES[@]}"; do
	# add || true to allow them to fail, in case they are already masked
	systemctl --user disable --now "$service" 2>/dev/null || true
	systemctl --user mask "$service" 2>/dev/null || true
done

Logger "Remove bloat packages..."
sudo dnf remove -y -q "${PACKAGES_REMOVE[@]}"

Logger "Enable touchegg..."
sudo systemctl enable --now touchegg.service

Logger "Enable fstrim..."
sudo systemctl enable --now fstrim.timer

Logger "Enable power management..."
sudo systemctl enable --now tlp

Logger "Enable power management - i915..."
if [ ! -f /etc/modprobe.d/i915.conf ]; then
	echo 'options i915 disable_power_well=0 enable_dc=2 enable_psr=1 enable_rc6=7 enable_fbc=1 powersave=1' | sudo tee /etc/modprobe.d/i915.conf
fi
if [ ! -f /etc/modprobe.d/snd_hda_intel.conf ]; then
	echo 'options snd_hda_intel power_save_controlle=Y power_save=1' | sudo tee /etc/modprobe.d/snd_hda_intel.conf
fi
if [ ! -f /etc/modprobe.d/e1000e.conf ]; then
	echo 'options e1000e SmartPowerDownEnable=1' | sudo tee /etc/modprobe.d/e1000e.conf
fi
if [ ! -f /etc/modprobe.d/iwlwifi.conf ]; then
	echo 'options iwlwifi power_save=Y power_level=5 iwlmvm power_scheme=3' | sudo tee /etc/modprobe.d/iwlwifi.conf
fi

Logger "Enable power management - grub..."
line="quiet nmi_watchdog=0 pcie_aspm.policy=powersupersave pcie_aspm=force drm.debug=0 drm.vblankoffdelay=1 scsi_mod.use_blk_mq=1 mmc_mod.use_blk_mq=1"
if ! grep -q "$line" /etc/default/grub 2>/dev/null; then
	sudo sed -i "s/quiet/quiet $line/g" /etc/default/grub
	sudo grub2-mkconfig -o /boot/grub2/grub.cfg
	sudo dracut --force --regenerate-all -v
fi

Logger "Enable power management - udev..."
if [ ! -f /etc/udev/rules.d/powersave.rules ]; then
	echo '
	  # ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="ahci", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="min_power"
      ACTION=="add", SUBSYSTEM=="scsi", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="acpi", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="block", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="workqueue", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="i2c", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp*", RUN+="/usr/sbin/ethtool -s %k wol d"
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlp*", RUN+="/usr/sbin/ethtool -s %k wol d"
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlp*", RUN+="/usr/sbin/iw dev %k set power_save on"
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/read_ahead_kb}="65536"
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/iosched/low_latency}="1"
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/iosched/low_latency}="1"
      ACTION=="add|change", KERNEL=="sd[a-z]", RUN+="/usr/sbin/hdparm -B 1 /dev/%k"' | sudo tee /etc/udev/rules.d/powersave.rules
fi

Logger "Setup tlp..."
line='USB_BLACKLIST="8087:07dc"'
if ! grep -q "$line" /etc/tlp.conf 2>/dev/null; then
	echo "$line" | sudo tee -a /etc/tlp.conf
fi

Logger "Enable power management - sysctl..."
for line in "${SYSCTL_FLAGS[@]}"; do
	if ! grep -q "$line" /etc/sysctl.conf 2>/dev/null; then
		echo "$line" | sudo tee -a /etc/sysctl.conf
	fi
done
sudo sysctl -p -q

Logger "Enable Tmpfs /tmp..."
line="tmpfs /tmp tmpfs defaults"
if ! grep -q "$line" /etc/fstab 2>/dev/null; then
	echo "$line" | sudo tee -a /etc/fstab
fi

Logger "Tweak btrfs noatime/nodiratime..."
line="noatime,nodiratime,compress=lzo,ssd,inode_cache,space_cache,subvol"
if ! grep -q "$line" /etc/fstab 2>/dev/null; then
	sudo sed -i "s/subvol/$line/g" /etc/fstab
fi

Logger "Enable noatime nodiratime..."
line="defaults,noatime,nodiratime"
if ! grep -q "$line" /etc/fstab 2>/dev/null; then
	sudo sed -i "s/defaults/$line/g" /etc/fstab
fi

# If we have intel graphics, set tearfree
if glxinfo | grep Device | grep -q Intel; then
	Logger "Setup intel tearfree..."
	echo 'Section "Device"
  Identifier "Intel Graphics"
  Driver "intel"

  Option "TearFree" "true"
EndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf
fi

clean
