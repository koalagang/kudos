{ config, ... }:

{
  # Besides iwc (which will be removed later),
  # these are all the "misc" aliases I use.
  # Most aliases are located in the file for the respective software.
  # For instance, in zathura's nix config I've defined za = "zathura"
  home.shellAliases = {
    grep = "grep --colour=auto";
    G = "grep --colour=auto";
    A = "awk";
    C = "cut";
    E = "echo";
    S = "sed";
    df = "df -h";

    gdir = "cd ${config.xdg.userDirs.desktop}/git";
    desk = "cd ${config.xdg.userDirs.desktop}";
    doc  = "cd ${config.xdg.userDirs.documents}";
    dl   = "cd ${config.xdg.userDirs.download}";
    pic  = "cd ${config.xdg.userDirs.pictures}";
    vid  = "cd ${config.xdg.userDirs.videos}";

    "..." = "cd ../..";
    "...." = "cd ../../..";
    # TODO: write a function that allows you to write any number+dots
    # e.g. 7. should send you seven directories up

    # TODO: write iwtui (an iwd tui) using dialog
    iwc = "iwctl station wlan0";
  };
}
