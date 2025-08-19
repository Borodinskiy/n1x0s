{ config, lib, ... }:
let
  cfg = config.module.include;
  purp = config.module.purpose;
  option = default: description: lib.mkEnableOption description // {
    inherit default;
  };
in
{
  options.module.include = {
    common = lib.mkEnableOption "default sigma software set";

    develop = option (cfg.common || purp.home) "IDE for developing";
    fonts  = option (cfg.common || purp.home) "font packages and settings";
    gaming = option (cfg.common || purp.home) "game centers and utilities";
    office = option (cfg.common || purp.home) "software for work with documents";
    pentest = option purp.home "utilities for penetration testing and ctf";
    printscan = option (cfg.common || purp.home) "physical work with documents (printers, scanners)";
    redactor = option (cfg.common || purp.home) "software for editing media: video, images, audio";
    surf = option (cfg.common || purp.home) "browsers, multimedia players, etc";
    virtualisation = {
      libvirt = option purp.home "libvirt setup";
      virtualbox = option purp.home "virtualbox setup";
      docker = option (purp.home || purp.server) "docker setup";
      qemu = option purp.home "qemu package";
    };
    wmTools = lib.mkEnableOption "programs for wayland compositors";
    windowsDualboot = lib.mkEnableOption "extra options when do a dualboot with windows";
    binaryCacheServer = lib.mkEnableOption "binary cache server for sharing builded nix packages with other machines";
  };
}
