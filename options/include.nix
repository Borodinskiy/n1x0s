{ config, lib, ... }:
let
  cfg = config.module.include;
  purp = config.module.purpose;
in
{
  options.module.include = {
    common = lib.mkEnableOption "default sigma software set";

    develop = lib.mkEnableOption "IDE for developing" // {
      default = cfg.common || purp.home;
    };
    fonts = lib.mkEnableOption "font packages and settings" // {
      default = cfg.common || purp.home;
    };
    gaming = lib.mkEnableOption "game centers and utilities" // {
      default = cfg.common || purp.home;
    };
    office = lib.mkEnableOption "software for work with documents" // {
      default = cfg.common || purp.home;
    };
    pentest = lib.mkEnableOption "utilities for penetration testing and ctf" // {
      default = cfg.common || purp.home;
    };
    printscan = lib.mkEnableOption "physical work with documents (printers, scanners)" // {
      default = cfg.common || purp.home;
    };
    redactor = lib.mkEnableOption "software for editing media: video, images, audio" // {
      default = cfg.common || purp.home;
    };
    surf = lib.mkEnableOption "browsers, multimedia players, etc" // {
      default = cfg.common || purp.home;
    };
    virtualisation = lib.mkEnableOption "vm utilities" // {
      default = cfg.common || purp.home;
    };
    wmTools = lib.mkEnableOption "programs for wayland compositors";

    windowsDualboot = lib.mkEnableOption "extra options when do a dualboot with windows";

    binaryCache = lib.mkEnableOption "binary cache serving on 80 port";

  };
}
