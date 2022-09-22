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
  helm
  iproute
  iputils
  jq
  kubernetes-client
  lm_sensors
  lsof
  make
  net-tools
  nmap
  openssl
  powertop
  procps
  psmisc
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

GOLANG_PACKAGES="
  golang
"

sudo dnf install -y ${ARCHIVE_PACKAGES} ${PYTHON_PACKAGES} ${TERMINAL_PACKAGES} ${GOLANG_PACKAGES}

PYTHON_MODULES="
  python-lsp-server[all]
  pyls-flake8
  pyls-isort
  flake8-awesome
  flake8-docstrings
  flake8-eradicate
  setuptools
  ansible-later
  ansible-lint
  demjson
  neovim
  psutil
  six
  yamllint
  bashate
"

sudo pip3 install -U setuptools==57.5.0
sudo pip3 install ${PYTHON_MODULES}

GOLANG_MODULES="
  golang.org/x/lint/golint@latest
  golang.org/x/tools/cmd/goimports@latest
  golang.org/x/tools/cmd/gorename@latest
  golang.org/x/tools/cmd/guru@latest
  golang.org/x/tools/gopls@latest
  mvdan.cc/sh/v3/cmd/shfmt@latest
"

for gopkg in ${GOLANG_MODULES}; do
	sudo GOBIN=/usr/local/bin go install "${gopkg}"
done

if [ ! -e /usr/local/bin/golangci-lint ]; then
	curl -sSfL \
		https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sudo sh -s -- -b /usr/local/bin
fi
