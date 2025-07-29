{ pkgs, ... }:
let
  package =
    with pkgs;
    writeShellScriptBin "hook" # bash
      ''
        # Helpful to read output when debugging
        set -x

        systemctl() {
          "${systemd}/bin/systemctl" "$@"
        }
        virsh() {
          "${libvirt}/bin/virsh" "$@"
        }

        # Check if vm have "vfio" in it's name
        [ "$(echo "$1" | grep "vfio")" == "" ] && exit 0
        # Check if hook was executed by "prepare begin" arguments
        [ "$(echo "''${*:2}" | grep "prepare begin")" == "" ] && exit 0

        if systemctl --quiet is-active sing-box.service; then
          systemctl stop sing-box.service
        fi
        if ! systemctl --quiet is-active sshd.service; then
          systemctl start sshd.service
          iptables -I nixos-fw 3 -p tcp -m tcp --dport 40242 -j nixos-fw-accept
        fi

        while systemctl --quiet is-active display-manager.service; do
          # Stop display manager
          systemctl stop display-manager.service
          ## Uncomment the following line if you use GDM
          #killall gdm-x-session
          sleep 5
        done

        rmmod nvidia_drm
        rmmod nvidia_uvm
        rmmod nvidia_modeset
        rmmod nvidia

        # Unbind VTconsoles
        echo 0 > /sys/class/vtconsole/vtcon0/bind

        # Unbind EFI-Framebuffer
        echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

        # Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
        sleep 2

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
