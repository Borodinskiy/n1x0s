# 🍞🥐🥖 N1X0S 🫓🥪🥙

## Description
Flake based configuration for NixOS \
Inputs:
- Nixpkgs stable
- Nixpkgs unstable
- Home-manager module
- Disko module

## Structure

Flake juggles and plays with next directories:
- **hosts**: configuration per machine
  - **hostname**
    - **module-name** (example: home-manager): extra configuration for *flake inputs* modules
- **modules**: configuration per *flake inputs* module (mostly for home-manager)
  - **module-name**
- **nixos**: system configuration. Somewhere subfolders are used for better organisation
- **options**: custom options, that's path should start with "`module.`". Used in all configuration places for tweaking things
- **overlays**: pkgs (and probably others) overlays. Used for custom packages and nixpkgs channels
- **pkgs**: custom packages derivations. Used in chain with overlays
- **resources**: files, that could be copied somewhere in system. Path to this directory can be aquired by using resourcesPath variable.

Those directories should contain a default.nix file, that import necessary things. For automated imports generation "lsDir" function was introduced in flake.nix (returns non recursive list of *.nix files in provided path)

## Usage
1. Simply copy content to /etc/nixos and do this:
```
# nixos-rebuild switch
```
2. Use something like this:
```
# nixos-rebuild --flake ~/path/to/this/flake switch
```
3. Automatically fetch this repo and apply configuration:
```
# nixos-rebuild --flake github:borodinskiy/n1x0s switch
```
