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


ARCHIVE_PACKAGES="
  cabextract
  lzip
  p7zip
  p7zip-full
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
  clang-tools
  ctags
  devscripts
  dos2unix
  file
  git
  git-credential-libsecret
  golang
  iproute
  iputils
  sensors
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

sudo zypper install -y ${ARCHIVE_PACKAGES} ${PYTHON_PACKAGES} ${TERMINAL_PACKAGES}
