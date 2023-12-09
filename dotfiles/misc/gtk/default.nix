{ pkgs, config, ... }:

{
  gtk = {
    enable = true;

    # TODO: stylix
    #font = {};
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
    };

    # Respect the XDG base directory spec for gtk2
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    # Don't log opened files (~/.local/share/recently-used.xbel)
    gtk2.extraConfig = "gtk-recent-files-max-age = 0";
    gtk3.extraConfig.gtk-recent-files-max-age = 0;
    gtk4.extraConfig.gtk-recent-files-max-age = 0;
  };
}
