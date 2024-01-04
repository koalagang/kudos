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

    # trash-cli
    tp  = "${pkgs.trash-cli}/bin/trash-put";
    tl  = "${pkgs.trash-cli}/bin/trash-list";
    te  = "${pkgs.trash-cli}/bin/trash-empty";
    trm = "${pkgs.trash-cli}/bin/trash-rm";
    tre = "${pkgs.trash-cli}/bin/trash-restore"; # tr is already a different command so an 'e' is added

    "..." = "cd ../..";
    "...." = "cd ../../..";

    # misc
    du = "${pkgs.du-dust}/bin/dust";

    # TODO: write iwtui (an iwd tui) using dialog
    iwc = "iwctl station wlan0";
  };
}
