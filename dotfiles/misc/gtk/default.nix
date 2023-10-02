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

    # Don't dump the gtk2 config in the home directory
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };
}
