{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  environment.systemPackages = with pkgs; [
    # Dependency of Lazy nvim plugin manager
    lua5_1
    lua51Packages.luarocks
  ];
}
