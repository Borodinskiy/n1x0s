{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.module.include.fonts;
in
{
  config = lib.mkIf cfg {
    fonts.packages =
      with pkgs;
      [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        liberation_ttf
        comic-mono
        nerd-fonts.symbols-only
        # MS .docx compatibility
        corefonts
        vistafonts
      ]

      ++ (with config.module.theme.font; [
        text.package
        mono.package
        mono.packageNerd
      ]);
  };
}
