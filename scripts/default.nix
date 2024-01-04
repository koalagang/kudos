{ pkgs, ... }:

{
  home.sessionVariables = {
    # this can be dmenu itself or anything that is dmenu compatible
    # e.g. rofi -dmenu, bemenu, etc.
    DMENU_CMD = "${pkgs.fuzzel}/bin/fuzzel --dmenu";

    # make sure these commands use the system clipboard
    # (rather than e.g. the primary or secondary clipboard)
    COPY_CMD = "${pkgs.wl-clipboard}/bin/wl-copy";
    PASTE_CMD = "${pkgs.wl-clipboard}/bin/wl-paste";
  };

  imports = [
    # dmenu scripts
    ./calcmenu.nix
    ./emojimenu.nix
    ./killmenu.nix
    ./transmenu.nix

    # misc
    ./pomo.nix

    # More to come...
  ];
}
