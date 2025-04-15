{ config, lib, ... }:
let
  cfg = config.module.include.gaming;
in
{
  config = lib.mkIf cfg {
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
      settings = {
        font_scale = 1;
        font_size = 22;
        font_size_text = 22;

        cpu_temp = true;
        cpu_power = true;
        cpu_mhz = true;
        gpu_temp = true;
        gpu_core_clock = true;
        gpu_power = true;

        io_read = true;
        io_write = true;

        vram = true;
        ram = true;

        fps = true;
        frametime = true;

        engine_version = true;
        engine_short_names = true;
        vulkan_driver = true;
        wine = true;
        exec_name = true;
        winesync = true;

        arch = true;
        gamemode = true;

        no_display = true;
      };
    };
  };
}
