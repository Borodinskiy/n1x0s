{ inputs, ... }:
{
  custom = final: _prev: import ../packages final.pkgs;

  unstable = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
    };
  };
}
