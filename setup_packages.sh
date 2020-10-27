#!/bin/sh

# Install base term_pkgs
sudo dnf update -y &&
sudo dnf install -y \
        ShellCheck \
        ccze \
        clang \
        clang-tools-extra \
        ctags \
        ctags-etags \
        git \
        git-credential-libsecret \
        golang \
        htop \
        make \
        python3-devel \
        python3-pip \
        tmux \
        vim \
        vim-enhanced && \
sudo dnf install -y \
        android-tools \
        gimp \
        keepassxc \
        mpv \
        gnome-shell-extension-appindicator \
        gnome-shell-extension-workspace-indicator \
        syncthing \
        telegram-desktop \
        evolution \
        evolution-ews && \
sudo dnf remove \
        NetworkManager-team \
        PackageKit \
        PackageKit-command-not-found \
        PackageKit-glib \
        PackageKit-gstreamer-plugin \
        PackageKit-gtk3-module \
        abrt \
        abrt-addon-ccpp \
        abrt-addon-kerneloops \
        abrt-addon-pstoreoops \
        abrt-addon-vmcore \
        abrt-addon-xorg \
        abrt-cli \
        abrt-dbus \
        abrt-desktop \
        abrt-gui \
        abrt-gui-libs \
        abrt-java-connector \
        abrt-libs \
        abrt-plugin-bodhi \
        abrt-retrace-client \
        abrt-tui \
        anaconda-widgets \
        appstream-data \
        authselect-compat \
        baobab \
        bcache-tools \
        blivet-data \
        blivet-gui-runtime \
        brasero-libs \
        catatonit \
        cheese \
        chkconfig \
        cldr-emoji-annotation \
        createrepo_c \
        createrepo_c-libs \
        criu \
        daxctl-libs \
        desktop-backgrounds-gnome \
        device-mapper-multipath \
        dleyna-connector-dbus \
        dleyna-core \
        dleyna-renderer \
        dleyna-server \
        dmraid \
        dmraid-events \
        dotconf \
        dracut-live \
        drpm \
        efivar-libs \
        enchant \
        espeak-ng \
        f32-backgrounds-base \
        f32-backgrounds-gnome \
        fedora-chromium-config \
        fedora-logos-httpd \
        fedora-release-workstation \
        fedora-workstation-backgrounds \
        fipscheck \
        fipscheck-lib \
        flashrom \
        freerdp-libs \
        frei0r-plugins \
        fuse-overlayfs \
        fwupd \
        gamemode \
        gavl \
        gdouros-symbola-fonts \
        gfbgraph \
        gnome-abrt \
        gnome-backgrounds \
        gnome-boxes \
        gnome-calendar \
        gnome-characters \
        gnome-classic-session \
        gnome-clocks \
        gnome-contacts \
        gnome-documents \
        gnome-font-viewer \
        gnome-getting-started-docs \
        gnome-initial-setup \
        gnome-logs \
        gnome-maps \
        gnome-menus \
        gnome-music \
        gnome-online-miners \
        gnome-photos \
        gnome-shell-extension-apps-menu \
        gnome-shell-extension-background-logo \
        gnome-shell-extension-horizontal-workspaces \
        gnome-shell-extension-launch-new-instance \
        gnome-shell-extension-places-menu \
        gnome-shell-extension-window-list \
        gnome-software \
        gnome-user-docs \
        gnome-user-share \
        gnome-video-effects \
        gnome-weather \
        gom \
        grilo \
        grilo-plugins \
        grub2-pc \
        grub2-pc-modules \
        grub2-tools-extra \
        gstreamer1-plugin-openh264 \
        hfsplus-tools \
        httpd \
        httpd-filesystem \
        httpd-tools \
        hyperv-daemons \
        hyperv-daemons-license \
        hypervfcopyd \
        hypervkvpd \
        hypervvssd \
        ibus-hangul \
        ibus-kkc \
        ibus-libpinyin \
        ibus-libzhuyin \
        ibus-m17n \
        ibus-qt \
        ibus-typing-booster \
        isomd5sum \
        kernel-modules-extra \
        keybinder3 \
        kyotocabinet-libs \
        langtable \
        libXres \
        libao \
        libblockdev-btrfs \
        libblockdev-dm \
        libblockdev-kbd \
        libblockdev-lvm \
        libblockdev-mpath \
        libblockdev-nvdimm \
        libblockdev-plugins-all \
        libblockdev-vdo \
        libbsd \
        libchamplain \
        libchamplain-gtk \
        libdazzle \
        libdmapsharing \
        libftdi \
        libgcab1 \
        libgdither \
        libhangul \
        libjcat \
        libkkc \
        libkkc-common \
        libkkc-data \
        liblouis \
        libmusicbrainz5 \
        libnet \
        libnl3-cli \
        liboauth \
        libpinyin \
        libpinyin-data \
        libreport-gtk \
        libreport-plugin-reportuploader \
        libsmbios \
        libteam \
        libtimezonemap \
        libtomcrypt \
        libvarlink-util \
        libvirt-gconfig \
        libvirt-gobject \
        libwinpr \
        libwnck3 \
        libxmlb \
        libzapojit \
        libzhuyin \
        lldpad \
        lrzsz \
        lxpolkit \
        m17n-db \
        m17n-lib \
        mactel-boot \
        marisa \
        mcelog \
        media-player-info \
        memtest86+ \
        mod_dnssd \
        mod_http2 \
        mtools \
        ndctl \
        ndctl-libs \
        oddjob \
        oddjob-mkhomedir \
        open-vm-tools \
        open-vm-tools-desktop \
        openh264 \
        openssh-askpass \
        orca \
        ostree \
        passwdqc-lib \
        pcaudiolib \
        pcsc-lite \
        pinentry-gnome3 \
        python3-abrt \
        python3-abrt-addon \
        python3-beaker \
        python3-beautifulsoup4 \
        python3-blivet \
        python3-blockdev \
        python3-brlapi \
        python3-bytesize \
        python3-dasbus \
        python3-enchant \
        python3-humanize \
        python3-inotify \
        python3-kickstart \
        python3-louis \
        python3-lxml \
        python3-mako \
        python3-meh \
        python3-ntplib \
        python3-ordered-set \
        python3-paste \
        python3-pid \
        python3-productmd \
        python3-pwquality \
        python3-pyOpenSSL \
        python3-pyatspi \
        python3-pyparted \
        python3-pyudev \
        python3-pyxdg \
        python3-requests-file \
        python3-requests-ftp \
        python3-simpleline \
        python3-soupsieve \
        python3-speechd \
        python3-tempita \
        python3-tkinter \
        qemu-guest-agent \
        rdist \
        redhat-menus \
        rhythmbox \
        rpmfusion-free-appstream-data \
        rpmfusion-nonfree-appstream-data \
        sg3_utils-libs \
        sgpio \
        shotwell \
        simple-scan \
        skkdic \
        slirp4netns \
        speech-dispatcher \
        speech-dispatcher-espeak-ng \
        spice-vdagent \
        sushi \
        teamd \
        tigervnc-license \
        tigervnc-server-minimal \
        totem \
        udisks2-iscsi \
        unicode-ucd \
        unoconv \
        usermode \
        virtualbox-guest-additions \
        xmlsec1-openssl \
        yelp \
        yelp-libs \
        yelp-xsl

# Install golang packages
export GOPATH=~/.local/go;go get golang.org/x/tools/gopls && \
export GOPATH=~/.local/go;go get github.com/go-delve/delve/cmd/dlv && \
export GOPATH=~/.local/go;go get golang.org/x/lint/golint && \
export GOPATH=~/.local/go;go get golang.org/x/tools/cmd/goimports && \
export GOPATH=~/.local/go;go get golang.org/x/tools/cmd/gorename && \
export GOPATH=~/.local/go;go get golang.org/x/tools/cmd/guru && \
export GOPATH=~/.local/go;go get mvdan.cc/sh/cmd/shfmt && \
rm -rf $GOPATH/src && \

# Install python packages
pip3 install --no-cache --user -U 'python-language-server[all]' \
        ansible \
        ansible-lint \
        astroid \
        autopep8 \
        flake8 \
        flake8-awesome \
        flake8-docstrings \
        flake8-eradicate \
        flake8-mypy \
        isort \
        jedi \
        lazy-object-proxy \
        lz4 \
        mccabe \
        molecule \
        neovim \
        parso \
        pluggy \
        psutil \
        pycodestyle \
        pydocstyle \
        pyflakes \
        pykeepass \
        pylint \
        python-jsonrpc-server \
        rope \
        setuptools \
        six \
        snowballstemmer \
        toml \
        ujson \
        wrapt \
        yamllint \
        yapf \
        youtube-dl

# Mask user systemd units
systemctl --user disable --now goa-daemon.service
systemctl --user disable --now goa-identity-service.service
systemctl --user disable --now gvfs-goa-volume-monitor.service
systemctl --user disable --now tracker-extract.service
systemctl --user disable --now tracker-miner-fs.service
systemctl --user disable --now tracker-miner-rss.service
systemctl --user disable --now tracker-store.service
systemctl --user disable --now tracker-writeback.service
systemctl --user mask goa-daemon.service
systemctl --user mask goa-identity-service.service
systemctl --user mask gvfs-goa-volume-monitor.service
systemctl --user mask tracker-extract.service
systemctl --user mask tracker-miner-fs.service
systemctl --user mask tracker-miner-rss.service
systemctl --user mask tracker-store.service
systemctl --user mask tracker-writeback.service

# virt-manager
# libvirt
# libvirt-bash-completion
# libvirt-client
# libvirt-daemon
# libvirt-daemon-config-network
# libvirt-daemon-config-nwfilter
# libvirt-daemon-driver-interface
# libvirt-daemon-driver-libxl
# libvirt-daemon-driver-lxc
# libvirt-daemon-driver-network
# libvirt-daemon-driver-nodedev
# libvirt-daemon-driver-nwfilter
# libvirt-daemon-driver-qemu
# libvirt-daemon-driver-secret
# libvirt-daemon-driver-storage
# libvirt-daemon-driver-storage-core
# libvirt-daemon-driver-storage-disk
# libvirt-daemon-driver-storage-gluster
# libvirt-daemon-driver-storage-iscsi
# libvirt-daemon-driver-storage-iscsi-direct
# libvirt-daemon-driver-storage-logical
# libvirt-daemon-driver-storage-mpath
# libvirt-daemon-driver-storage-rbd
# libvirt-daemon-driver-storage-scsi
# libvirt-daemon-driver-storage-sheepdog
# libvirt-daemon-driver-storage-zfs
# libvirt-daemon-driver-vbox
# libvirt-daemon-kvm
# libvirt-glib
# libvirt-libs
