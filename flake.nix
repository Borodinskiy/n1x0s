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

      resourcePath = ./resources;

      # Default user, that will be used in most config places
      sigmaUser = "user";
      sigmaUid = 1337;
      sigmaUidStr = builtins.toString sigmaUid;

      # This function will non recursively show *.nix files and directories by path
      # Used in most config places, so no need to write huge default.nix file
      lsDir =
        path:
        map (file: "${path}/${file}") (
          builtins.filter (
            file:
            "${file}" != "default.nix"
            && builtins.readFileType "${path}/${file}" == "regular"
            && nixpkgs.lib.strings.hasSuffix ".nix" "${file}"
          ) (builtins.attrNames (builtins.readDir path))
        );

      # Default modules arrays

      defaultNixos = [
        ./options
        ./nixos
      ];

      nixosServer = [
        inputs.disko.nixosModules.disko
      ];

      defaultForModule = moduleName: [
        ./options
        ./modules/${moduleName}
      ];

      specialArgs = {
        inherit
          inputs
          outputs
          resourcePath
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
          modules = defaultNixos ++ extraModules ++ [ ./hosts/${hostname} ];
        };

      homeManager =
        hostname:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = specialArgs;
          modules = (defaultForModule "home-manager") ++ [ ./hosts/${hostname}/home-manager ];
        };

      hostLaptop = "HP1";
      hostPc = "bhd";

      hostServer = "costeglaz-inc";
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        "${hostLaptop}" = nixosSystem { hostname = "${hostLaptop}"; }; # laptop
        "${hostPc}" = nixosSystem { hostname = "${hostPc}"; }; # pc

        # hostServer
        "${hostServer}" = nixosSystem {
          hostname = "${hostServer}";
          extraModules = nixosServer;
        };
      };

      homeConfigurations = {
        "${sigmaUser}@${hostLaptop}" = homeManager "${hostLaptop}"; # Laptop
        "${sigmaUser}@${hostPc}" = homeManager "${hostPc}"; # hostPc
      };
    };
}
