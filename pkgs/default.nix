# Here should be provided custom packages names and pathes to it's derivation folders
pkgs: {
  sddm-custom-bg = pkgs.callPackage ./sddm-custom-bg { };

  # FIXME: No need in this packages after 25.05
  amneziawg-tools-custom = pkgs.callPackage ./amneziawg-tools { };
}
