{ pkgs, config, ... }:

{
  home.sessionVariables = {
    # this can be dmenu itself or anything that is dmenu compatible
    # e.g. rofi -dmenu, fuzzel --dmenu, bemenu, etc.
    # but don't add, -l -i or -p because those are hardcoded into the scripts
    DMENU_CMD = "${pkgs.bemenu}/bin/bemenu ${config.home.sessionVariables.BEMENU_OPTS}";
    # extra flags that you may want to use in some scripts but not others (e.g. centring the menu)
    # leave as an empty string if you don't intend to use this
    DMENU_EXTRA_FLAGS = "-c -W 0.33";

    # make sure these commands use the system clipboard
    # (rather than e.g. the primary or secondary clipboard)
    COPY_CMD = "${pkgs.wl-clipboard}/bin/wl-copy";
    PASTE_CMD = "${pkgs.wl-clipboard}/bin/wl-paste";
  };

  imports = [
    # dmenu scripts
    ./colourmenu.nix
    ./ddgmenu.nix
    ./emojimenu.nix
    ./killmenu.nix
    ./radiomenu.nix
    ./screenmenu.nix
    ./transmenu.nix
    ./ytmenu.nix

    # misc
    ./arc.nix
    ./pingable.nix
    ./pomo.nix
    ./taskdue.nix
  ];
}
