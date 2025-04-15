{
  description = "Sigma NIXOS configuration (c) LigmaBalls";

  inputs = {
    # Main repository with packages
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Utility for managing home directory via nix
    home-manager.url = "github:nix-community/home-manager?ref=release-24.11";
    # Automatic disk razmetka (for server)
    disko.url = "github:nix-community/disko";

    # Modules have it's own nixpkgs input. Syncing its with our's
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, self, ... }@inputs:
    let
      inherit (self) outputs;
      # For multi-arch setups (coming soon (2045))
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      # Alias for function that generate attrs for systems that defined in variable above
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Default user, that will be used in most config places
      sigmaUser = "borodinskiy";
      sigmaUid = 1337;
      sigmaUidStr = builtins.toString sigmaUid;

      lsDir =
        path:
        map (file: "${path}/${file}") (
          builtins.filter (
            file:
            builtins.readFileType "${path}/${file}" == "regular"
            && nixpkgs.lib.strings.hasSuffix ".nix" "${file}"
          ) (builtins.attrNames (builtins.readDir path))
        );

      # Default modules arrays

      defaultNixos = lsDir ./options ++ lsDir ./nixos;

      nixosServer = [
        inputs.disko.nixosModules.disko
      ];

      defaultForModule = moduleName: lsDir ./options ++ lsDir ./module/${moduleName};

      specialArgs = {
        inherit
          inputs
          outputs
          sigmaUser
          sigmaUid
          sigmaUidStr
          lsDir
          ;
      };

      nixosSystem =
        {
          hostname,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = defaultNixos ++ extraModules ++ (lsDir ./hosts/${hostname});
        };

      homeManager =
        hostname:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = specialArgs;
          modules = (defaultForModule "home-manager") ++ (lsDir ./hosts/${hostname}/home-manager);
        };

      hostLaptop = "HP1";
      hostPc = "bhd";
      hostUsb = "border";

      hostServer = "costeglaz-inc";
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        "${hostLaptop}" = nixosSystem { hostname = "${hostLaptop}"; }; # laptop
        "${hostPc}" = nixosSystem { hostname = "${hostPc}"; }; # pc
        "${hostUsb}" = nixosSystem { hostname = "${hostUsb}"; }; # usb multitool

        # hostServer
        "${hostServer}" = nixosSystem {
          hostname = "${hostServer}";
          extraModules = nixosServer;
        };
      };

      homeConfigurations = {
        "${sigmaUser}@${hostLaptop}" = homeManager "${hostLaptop}"; # Laptop
        "${sigmaUser}@${hostPc}" = homeManager "${hostPc}"; # hostPc
        "${sigmaUser}@${hostUsb}" = homeManager "${hostUsb}"; # USB multitoolh
      };
    };
}
