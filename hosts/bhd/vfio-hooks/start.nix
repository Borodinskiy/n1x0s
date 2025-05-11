{ pkgs, ... }:
let
  package =
    with pkgs;
    writeShellScriptBin "hook" # bash
      ''
        # Helpful to read output when debugging
        set -x
        echo "$(date) ''$*" >> "/tmp/start.txt"

        systemctl() {
          "${systemd}/bin/systemctl" "$@"
        }
        virsh() {
          "${libvirt}/bin/virsh" "$@"
        }

        [ "$(echo "$1" | grep "vfio")" == "" ] && exit 0
        [ "$(echo "''${*:2}" | grep "prepare begin")" == "" ] && exit 0
        echo '`-passed!!!' >> "/tmp/start.txt"

        # Stop display manager
        systemctl stop display-manager.service
        ## Uncomment the following line if you use GDM
        #killall gdm-x-session

        sleep 5

        rmmod nvidia_drm
        rmmod nvidia_uvm
        rmmod nvidia_modeset
        rmmod nvidia

        # Unbind VTconsoles
        echo 0 > /sys/class/vtconsole/vtcon0/bind

        # Unbind EFI-Framebuffer
        echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

        # Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
        sleep 1

        # Unbind the GPU from display driver
        virsh nodedev-detach pci_0000_01_00_0
        virsh nodedev-detach pci_0000_01_00_1
        virsh nodedev-detach pci_0000_01_00_2
        virsh nodedev-detach pci_0000_01_00_3
        virsh nodedev-detach pci_0000_00_1f_3
      '';
in
{
  virtualisation.libvirtd.hooks.qemu."hook-s" = package + "/bin/hook";
}
