# Here should be provided custom packages names and pathes to it's derivation folders
pkgs: {
  n1x0s-grub = pkgs.callPackage ./n1x0s-grub {};
  sddm-custom-bg = pkgs.callPackage ./sddm-custom-bg { };

  # FIXME: No need in this packages after 25.05
  amneziawg-tools-custom = pkgs.callPackage ./amneziawg-tools { };
}
