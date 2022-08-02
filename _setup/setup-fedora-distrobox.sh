#!/bin/sh

if [ "$(id -ru)" -eq 0 ]; then
	echo "Please run WITHOUT ROOT"
	exit
fi
set -o errexit
set -o nounset

# Append line to file only if does not exist.
# Arguments:
#   string_to_append
#   file_to_target
# Outputs:
#   none
append_if_not_exists() {
	string="${1}"
	file="${2}"
	if ! grep -q "${string}" "${file}" 2> /dev/null; then
		echo "${string}" | sudo tee -a "${file}"
	fi
}

sudo dnf install -y \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

DNF_TWEAKS="
  deltarpm=True
  fastestmirror=True
  install_weak_deps=False
  max_parallel_downloads=10
"
for value in ${DNF_TWEAKS}; do
	append_if_not_exists "${value}" /etc/dnf/dnf.conf
done

# sudo dnf update -y --refresh


ARCHIVE_PACKAGES="
  cabextract
  lzip
  p7zip
  p7zip-plugins
  unzip
  zstd
"
PYTHON_PACKAGES="
  python3
  python3-pip
  python3-wheel
  python3-devel
"
TERMINAL_PACKAGES="
  ShellCheck
  acpi
  bash-completion
  bc
  binwalk
  clang
  clang-tools-extra
  ctags
  devscripts
  dos2unix
  file
  git
  git-credential-libsecret
  golang
  iproute
  iputils
  lm_sensors
  lsof
  make
  net-tools
  nmap
  openssl
  powertop
  procps
  rsync
  sqlite
  stow
  syncthing
  tcpdump
  tig
  tmux
  tree
  vim
  wl-clipboard
  wmctrl
  xclip
  xdotool
  xlsclients
"

sudo dnf install -y ${ARCHIVE_PACKAGES} ${PYTHON_PACKAGES} ${TERMINAL_PACKAGES}
