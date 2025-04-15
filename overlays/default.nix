{ inputs, ... }:
{
  additions = final: _prev: import ../pkgs final.pkgs;
  unstable = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
    };
  };
}
