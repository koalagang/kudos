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
    # trash a file
    tp = "${pkgs.trashy}/bin/trash put";
    # list contents of trash
    tl = "${pkgs.trashy}/bin/trash list";
    # delete all files in trash
    te = "${pkgs.trashy}/bin/trash empty --all";
    # follow this with the ID of the trashed file you want to delete
    trm = "${pkgs.trashy}/bin/trash empty";
    # search the trash and *restore* the file(s) you select (can select multiple by using shift+tab)
    trf = "${pkgs.trashy}/bin/trash list | ${pkgs.fzf}/bin/fzf --multi | ${pkgs.gawk}/bin/awk '{ print $NF }' |
      ${pkgs.findutils}/bin/xargs ${pkgs.trashy}/bin/trash restore --match=exact";
    # search the trash and *delete* the file(s) you select (can select multiple by using shift+tab)
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
