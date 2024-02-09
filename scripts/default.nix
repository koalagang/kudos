{ pkgs, ... }:

{
  home.sessionVariables = {
    # this can be dmenu itself or anything that is dmenu compatible
    # e.g. rofi -dmenu, fuzzel --dmenu, bemenu, etc.
    DMENU_CMD = "${pkgs.bemenu}/bin/bemenu";

    # make sure these commands use the system clipboard
    # (rather than e.g. the primary or secondary clipboard)
    COPY_CMD = "${pkgs.wl-clipboard}/bin/wl-copy";
    PASTE_CMD = "${pkgs.wl-clipboard}/bin/wl-paste";
  };

  imports = [
    # dmenu scripts
    ./colourmenu.nix
    ./emojimenu.nix
    ./killmenu.nix
    ./radiomenu.nix
    ./transmenu.nix
    ./screenmenu.nix

    # misc
    ./pomo.nix
    ./pingable.nix
    ./taskdue.nix
    ./arc.nix

    # More to come...
  ];
}
