#!/bin/sh

if [ "$(id -ru)" -ne 0 ]; then
	echo "Please run as root"
	exit
fi
set -o errexit
set -o nounset

SYSTEMD_SERVICES="
  NetworkManager-wait-online.service
  auditd.service
  dnf-makecache.timer
  import-state.service
  kdump.service
  livesys-late.sevice
  livesys.service
  nis-domainname.service
  sssd.service
  switcheroo-control.service
  unbound-anchor.timer
"
echo "#### Disabling system bloat services..."
for service in ${SYSTEMD_SERVICES}; do
	if systemctl disable --now "${service}"; then
		systemctl mask "${service}" ||:
	fi
done

echo "#### Setting up udev powersave values..."
cat << EOF > /etc/udev/rules.d/powersave.rules
ACTION=="add|change", SUBSYSTEM=="acpi", ATTR{power/control}="auto"
ACTION=="add|change", SUBSYSTEM=="ahci", ATTR{power/control}="auto"
ACTION=="add|change", SUBSYSTEM=="block", ATTR{power/control}="auto"
ACTION=="add|change", SUBSYSTEM=="i2c", ATTR{power/control}="auto"
ACTION=="add|change", SUBSYSTEM=="net", KERNEL=="enp*", RUN+="/usr/sbin/ethtool -s %k wol d"
ACTION=="add|change", SUBSYSTEM=="net", KERNEL=="wlp*", RUN+="/usr/sbin/iw dev %k set power_save on"
ACTION=="add|change", SUBSYSTEM=="pci", ATTR{power/control}="auto"
ACTION=="add|change", SUBSYSTEM=="scsi", ATTR{power/control}="auto"
ACTION=="add|change", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="min_power"
ACTION=="add|change", SUBSYSTEM=="usb", ATTR{power/autosuspend}="1"
ACTION=="add|change", SUBSYSTEM=="workqueue", ATTR{power/control}="auto"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/iosched/low_latency}="1"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/scheduler}="bfq"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/read_ahead_kb}="4096"
ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/read_ahead_kb}="16384"
# ACTION=="add|change", SUBSYSTEM=="power_supply", RUN+="/usr/sbin/powertop --auto-tune"
# SUBSYSTEM=="power_supply",ENV{POWER_SUPPLY_ONLINE}=="0",RUN+="/usr/sbin/powertop --auto-tune"
EOF

if [ -e /etc/lvm/lvm.conf ]; then
	echo "Setting up lvm discards..."
	sed -i 's/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf
fi

if [ -e /etc/crypttab ]; then
	echo "Setting up crypttab performance..."
	sed -i 's/none discard$/none discard,no-read-workqueue,no-write-workqueue/g' /etc/crypttab
	sed -i 's/x-initrd.attach$/x-initrd.attach,discard,no-read-workqueue,no-write-workqueue/g' /etc/crypttab

    volume="$(cat /etc/crypttab  | cut -d' ' -f1)"
	cryptsetup --allow-discards --perf-no_read_workqueue --perf-no_write_workqueue --persistent refresh "$volume"
fi

GRUB_FLAGS="
 amdgpu.aspm=1
 amdgpu.cik_support=1
 amdgpu.dc=1
 amdgpu.dcfeaturemask=0xB
 amdgpu.si_support=1
 dm_mod.use_blk_mq=1
 drm.debug=0
 drm.vblankoffdelay=1
 e1000e.SmartPowerDownEnable=1
 i915.disable_power_well=0
 i915.enable_dc=2
 i915.enable_fbc=1
 i915.enable_guc=3
 i915.enable_psr=1
 i915.enable_rc6=7
 i915.powersave=1
 iwlmvm.power_scheme=3
 iwlwifi.power_level=5
 iwlwifi.power_save=Y
 mitigations=off
 mmc_mod.use_blk_mq=1
 nvme_core.default_ps_max_latency_us=20000
 nvme_core.force_apst=1
 pcie_aspm.policy=powersupersave
 pcie_aspm=force
 scsi_mod.use_blk_mq=1
 snd_ac97_codec.power_save=1
 snd_hda_intel.power_save=1
 snd_hda_intel.power_save_controller=Y
 thinkpad_acpi.fan_control=1
 usbcore.autosuspend=1
"
echo "#### Setting up grub flags..."
sed -i "s|mitigations=auto||g" /etc/default/grub
for flag in $GRUB_FLAGS; do
	if ! grep -q "${flag}" /etc/default/grub; then
		sed -i "s|GRUB_CMDLINE_LINUX=\"|GRUB_CMDLINE_LINUX=\"${flag} |g" /etc/default/grub
	fi
done

echo "#### Removing unused system flatpaks..."
flatpak --system uninstall --all
flatpak --system remote-delete fedora || :

# echo "#### Setting up distro packages..."
# if command -v rpm-ostree > /dev/null; then
# 	rpm-ostree override remove gnome-software gnome-software-rpm-ostree firefox
# 	for i in $(grep GRUB_CMDLINE_LINUX /etc/default/grub | grep -Eo "rhgb quiet.*" | cut -d' ' -f3- | tr -d '"'); do
# 		rpm-ostree kargs --append-if-missing=$i
# 	done
# elif command -v tukit > /dev/null; then
# 	tukit --discard --continue execute bash -c "
# 	zypper addlock yast2;
# 	zypper rm -y gnome-software;
# 	find /boot -name "grub.cfg" | xargs -I{} grub2-mkconfig -o {};
#         dracut --force --regenerate-all;
#     "
# fi
