{
  description = "Sigma NIXOS configuration (c) LigmaBalls";

  inputs = {
    # Main repositories with packages
    stable.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Default nixpkgs version
    nixpkgs.follows = "unstable";

    # Declarative disk partitioning (for server)
    disko = {
      url = "github:nix-community/disko";
      # Modules have it's own nixpkgs input. Syncing its with our's for disk economy (no)
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

      # Where located files that could be used in configuration
      resourcePath = ./assets;

      # Default user, that will be used in most configuration places
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

      hostLaptop = "HP1";
      hostPc = "bhd";

      hostServer = "costeglaz-inc";
    in
    {
      packages = forAllSystems (system: import ./packages nixpkgs.legacyPackages.${system});

      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        "${hostLaptop}" = nixosSystem { hostname = "${hostLaptop}"; };
        "${hostPc}" = nixosSystem { hostname = "${hostPc}"; };

        "${hostServer}" = nixosSystem {
          hostname = "${hostServer}";
          extraModules = nixosServer;
        };
      };
    };
}
