{ pkgs, ... }:
let
  package =
    with pkgs;
    writeShellScriptBin "hook" # bash
      ''
        # Helpful to read output when debugging
        set -x
        echo "$(date) ''$*" >> "/tmp/revert.txt"

        systemctl() {
          "${systemd}/bin/systemctl" "$@"
        }
        virsh() {
          "${libvirt}/bin/virsh" "$@"
        }
        pgrep() {
          "${procps}/bin/pgrep" "$@"
        }

        [ "$(echo "$1" | grep "vfio")" == "" ] && exit 0
        [ "$(echo "''${*:2}" | grep "release end")" == "" ] && exit 0
        echo '`-passed!!!' >> "/tmp/revert.txt"

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

        # Restart Display Manager
        systemctl start display-manager.service
      '';
in
{
  virtualisation.libvirtd.hooks.qemu."hook-r" = package + "/bin/hook";
}
