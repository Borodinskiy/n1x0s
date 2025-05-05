{
  config,
  ...
}:
let
  theme = config.module.theme;
in
{
  gtk = {
    enable = true;
    font = with theme.font.text; {
      inherit package name size;
    };
    iconTheme = with theme.iconTheme; {
      inherit package name;
    };
    theme = with theme; {
      inherit package name;
    };
  };

  home.pointerCursor = with theme.cursor; {
    inherit package name size;
    gtk.enable = true;
    x11.enable = true;
  };
}
