{
  pkgs,
  config,
  lib,
  ...
}:
let
  group = config.module.include;
in
{
  fonts.packages =
    with pkgs;
    lib.optionals group.fonts [
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
}
