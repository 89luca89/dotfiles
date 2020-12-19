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
	"indicator-syncthing"
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

Logger "Add global variables..."
for line in "${GLOBAL_VARIABLES[@]}"; do
	if ! grep -q "$line" /etc/profile 2>/dev/null; then
		echo "$line" | sudo tee -a /etc/profile
	fi
done

Logger "Install user flathub..."
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

Logger "Install golang user packages..."
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

Logger "Install python user pagkages..."
/usr/bin/python3 -m pip install --no-input --no-cache --user -U pip
/usr/bin/python3 -m pip -q install --no-input --no-cache --user -U "${PIP_PACKAGES[@]}"

TERRAFORM_VERSION=0.13.0
TERRAFORM_LS_VERSION=0.8.0
TERRAFORM_PROVIDER_VERSION=0.6.3
TERRAFORM_PROVIDER_RELEASE=0.6.3+git.1604843676.67f4f2aa

Logger "Install terraform user packages..."
if ! command -v terraform 2>/dev/null; then
	curl -sLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/"$TERRAFORM_VERSION"/terraform_"$TERRAFORM_VERSION"_linux_amd64.zip
	unzip /tmp/terraform.zip -d /tmp
	mv /tmp/terraform ~/.local/bin
fi

Logger "Install terraform-ls user packages..."
if ! command -v terraform-ls 2>/dev/null; then
	curl -sLo /tmp/terraform-ls.zip https://releases.hashicorp.com/terraform-ls/"$TERRAFORM_LS_VERSION"/terraform-ls_"$TERRAFORM_LS_VERSION"_linux_amd64.zip
	unzip /tmp/terraform-ls.zip -d /tmp
	mv /tmp/terraform-ls ~/.local/bin
fi

# Install Terraform Provider for Libvirt 0.6.2
Logger "Install terraform provider libvirt user packages..."
if [ ! -f ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/"$TERRAFORM_PROVIDER_VERSION"/linux_amd64 ]; then
	mkdir -p ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/"$TERRAFORM_PROVIDER_VERSION"/
	curl -sLo /tmp/terraform-provider-libvirt.tar.gz https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v"$TERRAFORM_PROVIDER_VERSION"/terraform-provider-libvirt-"$TERRAFORM_PROVIDER_RELEASE".Fedora_32.x86_64.tar.gz
	tar zxvf /tmp/terraform-provider-libvirt.tar.gz -C /tmp/

fi

Logger "Enable touchegg..."
sudo cp ~/dotfiles/touchegg.service /usr/lib/systemd/system/touchegg.service
sudo systemctl daemon-reload
sudo systemctl enable touchegg.service
sudo systemctl restart touchegg.service

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

Logger "Setup font rendering..."
sudo ln -sf /usr/share/fontconfig/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
dconf write /org/gnome/settings-daemon/plugins/xsettings/antialiasing "'rgba'"
