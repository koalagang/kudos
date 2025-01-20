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

    # faster backwards cd'ing
    "..." = "cd ../..";
    "...." = "cd ../../..";

    # misc
    du = "${pkgs.du-dust}/bin/dust";
    img = "${pkgs.swayimg}/bin/swayimg";
    rd = "${pkgs.ripdrag}/bin/ripdrag";
    nx = "${pkgs.nh}/bin/nh"; # I find 'nh' a bit awkward to type because of the placement of the keys
    iwc = "iwctl station wlan0";
    imp = "${pkgs.impala}/bin/impala";
    wttr = "${pkgs.curl}/bin/curl wttr.in";
  };
}
