{ pkgs, ... }:

{
  home.sessionVariables = {
    # this can be dmenu itself or anything that is dmenu compatible
    # e.g. rofi -dmenu, fuzzel --dmenu, bemenu, etc.
    # but don't add any of the standard dmenu flags (e.g. -i or -p) because those are hardcoded in the scripts
    # TODO: nix-colors
    DMENU_CMD = "${pkgs.bemenu}/bin/bemenu --fb '#1e1e2e' --ff '#cdd6f4' --nb '#1e1e2e' --nf '#cdd6f4' --tb '#1e1e2e' --hb '#1e1e2e' --tf '#f38ba8' --hf '#f9e2af' --af '#cdd6f4' --ab '#1e1e2e' --bdr '#f38ba8' --fn 12 -H 40 -B 2 -R 10 -f";
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
