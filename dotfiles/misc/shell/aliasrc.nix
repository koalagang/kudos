{ pkgs, config, ... }:

{
  # Besides iwc (which will be removed later),
  # these are the aliases for which there are no configs.
  # Most aliases are located in the file for the respective software.
  # For instance, in zathura's nix config I've defined za = "zathura"
  home.shellAliases = {
    # GNU utilities
    grep = "${pkgs.gnugrep}/bin/grep --colour=auto";
    G  = "${pkgs.gnugrep}/bin/grep --colour=auto";
    A  = "${pkgs.gawk}/bin/gawk";
    S  = "${pkgs.gnused}/bin/sed";
    E  = "${pkgs.coreutils}/bin/echo";
    df = "${pkgs.coreutils}/bin/df -h";

    # trashy
    tp = "${pkgs.trashy}/bin/trash put";
    tl = "${pkgs.trashy}/bin/trash list";
    te = "${pkgs.trashy}/bin/trash empty --all";
    trm = "${pkgs.trashy}/bin/trash empty";
    trf = "${pkgs.trashy}/bin/trash list | ${pkgs.fzf}/bin/fzf --multi | ${pkgs.gawk}/bin/awk '{ print $NF }' |
      ${pkgs.findutils}/bin/xargs ${pkgs.trashy}/bin/trash restore --match=exact";
    tef = "${pkgs.trashy}/bin/trash list | ${pkgs.fzf}/bin/fzf --multi | ${pkgs.gawk}/bin/awk '{ print $NF }' |
      ${pkgs.findutils}/bin/xargs ${pkgs.trashy}/bin/trash empty --match=exact";

    # faster backwards cd'ing
    "..." = "cd ../..";
    "...." = "cd ../../..";

    # misc
    du = "${pkgs.du-dust}/bin/dust";
    img = "${pkgs.swayimg}/bin/swayimg";

    # TODO: write iwtui (an iwd tui) using dialog
    iwc = "iwctl station wlan0";
  };
}
