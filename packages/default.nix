# Here should be provided custom packages names and pathes to it's derivation folders
pkgs: {
  n1x0s-grub = pkgs.callPackage ./n1x0s-grub { };
  n1x0s-sddm = pkgs.callPackage ./n1x0s-sddm { };
  n1x0s-session = pkgs.callPackage ./n1x0s-session { };
}
