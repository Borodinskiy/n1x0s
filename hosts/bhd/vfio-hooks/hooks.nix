{ pkgs, ... }:
{
  virtualisation.libvirtd.hooks.qemu =
    with pkgs;
    let
      script =
        file:
        (writeShellScriptBin "hook" (
          ''
            # Helpful to read output when debugging
            set -x

            systemctl() {
            	"${systemd}/bin/systemctl" "$@"
            }
            virsh() {
            	"${libvirt}/bin/virsh" "$@"
            }
            pgrep() {
            	"${procps}/bin/pgrep" "$@"
            }
          ''
          + builtins.readFile file
        ))
        + "/bin/hook";
    in
    {
      "hook-s" = script ./start.sh;
      "hook-r" = script ./revert.sh;
    };
}
