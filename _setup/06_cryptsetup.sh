#!/bin/sh

set -o errexit
set -o nounset

disk="$(cat /etc/crypptab | cut -d' ' -f1)"

if command -v tukit > /dev/null; then
	tukit --discard --continue execute bash -c "
if [ ! -e /.root.key ]; then
	touch /.root.key;
	chmod 600 /.root.key;
	dd if=/dev/urandom of=/.root.key bs=1024 count=1;
	cryptsetup luksAddKey $disk /.root.key;
fi
sed -i 's|none|/.root.key|g' /etc/crypttab;
echo -e 'install_items+=" /.root.key "' > /etc/dracut.conf.d/99-root-key.conf;
if ! grep -q "root:root 700" /etc/permissions.local; then
	echo "/boot/ root:root 700" >> /etc/permissions.local;
	chkstat --system --set;
fi
mkinitrd;
"
fi
