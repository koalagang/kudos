{ pkgs, config, ... }:

{
  gtk = {
    enable = true;

    #font = {};
    theme = {
      # TODO: file an issue about there being no latte, macchiato or mocha
      # and with blue being the only accent colour
      name = "catppuccin-frappe-blue-standard";
      package = pkgs.catppuccin-gtk;
    };
    # there's no catppuccin icon theme in nixpkgs so I'll just use rose pine
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
    # the catppuccin cursors look ugly. the rose pine cursors looks nice.
    cursorTheme = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
    };

    # Respect the XDG base directory spec for gtk2
    # (gtk3 and 4 respect this by default but gtk2 does not)
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    # Don't log opened files (~/.local/share/recently-used.xbel)
    gtk2.extraConfig = "gtk-recent-files-max-age = 0";
    gtk3.extraConfig.gtk-recent-files-max-age = 0;
    gtk4.extraConfig.gtk-recent-files-max-age = 0;
  };
}
