{ pkgs, config, ... }:

{
  home.sessionVariables = {
    # this can be dmenu itself or anything that is dmenu compatible
    # e.g. rofi -dmenu, fuzzel --dmenu, bemenu, etc.
    # but don't add, -l -i or -p because those are hardcoded into the scripts
    # TODO: nix-colors
    DMENU_CMD = "${pkgs.bemenu}/bin/bemenu --fb '#${config.colorScheme.palette.base00}' --ff '#${config.colorScheme.palette.base05}' --nb '#${config.colorScheme.palette.base00}' --nf '#${config.colorScheme.palette.base05}' --tb '#${config.colorScheme.palette.base00}' --hb '#${config.colorScheme.palette.base00}' --tf '#${config.colorScheme.palette.base0E}' --hf '#${config.colorScheme.palette.base0B}' --af '#${config.colorScheme.palette.base05}' --ab '#${config.colorScheme.palette.base00}' --bdr '#${config.colorScheme.palette.base0E}' --fn 12 -H 40 -B 2 -R 10 -f";
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
