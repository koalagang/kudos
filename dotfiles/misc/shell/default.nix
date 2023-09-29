{ config, ... }:

{
  # TODO: functionrc with writeShellScriptBin

  home = {
    # Besides iwc (which will be removed later),
    # these are all the "misc" aliases I use.
    # Most aliases are located in the file for the respective tool.
    # For instance, in zathura's nix config I've defined za = "zathura"
    shellAliases = {
      grep = "grep --colour=auto";

      desk = "cd ${config.xdg.userDirs.desktop}";
      doc = "cd ${config.xdg.userDirs.documents}";
      dl = "cd ${config.xdg.userDirs.download}";
      pix = "cd ${config.xdg.userDirs.pictures}";
      vid = "cd ${config.xdg.userDirs.videos}";
      gdir = "cd ${config.xdg.userDirs.desktop}/git";

      "..." = "cd ../..";
      "...." = "cd ../../..";
      # TODO: write a function that allows you to do any number+dots
      # e.g. 7.. should send you seven directories up

      # TODO: write iwtui (an iwd tui) using whiptail
      iwc = "iwctl station wlan0";
    };
  };
}
