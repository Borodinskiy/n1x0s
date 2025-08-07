# Check if vm have "vfio" in it's name
[ "$(echo "$1" | grep "vfio")" == "" ] && exit 0
# Check if hook was executed by "release end" arguments
[ "$(echo "''${*:2}" | grep "release end")" == "" ] && exit 0

# Re-Bind GPU to Nvidia Driver
virsh nodedev-reattach pci_0000_01_00_0
virsh nodedev-reattach pci_0000_01_00_1
virsh nodedev-reattach pci_0000_01_00_2
virsh nodedev-reattach pci_0000_01_00_3
virsh nodedev-reattach pci_0000_00_1f_3

modprobe nvidia
modprobe nvidia_modeset
modprobe nvidia_uvm
modprobe nvidia_drm

# Rebind VT consoles
echo 1 > /sys/class/vtconsole/vtcon0/bind

echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

if ! systemctl --quiet is-active sing-box.service; then
	systemctl restart sing-box.service
fi
if systemctl --quiet is-active sshd.service; then
	systemctl stop sshd.service
	iptables -D nixos-fw -p tcp -m tcp --dport 40242 -j nixos-fw-accept
fi
while ! systemctl --quiet is-active display-manager.service; do
	systemctl restart display-manager.service
	sleep 5
done