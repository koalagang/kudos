{ config, ... }:

let
  profile0 = "browsing";
  profile1 = "signin";
in

{
  programs.firefox = {
    enable = true;
    profiles = {
      ${profile0} = import ./profiles/browsing.nix;
      ${profile1} = import ./profiles/signin.nix;
    };
  };

  # -- custom CSS
  # I've enabled custom css in settings.nix
  # There are userChrome and userContent options in homemanager
  # but there are so many CSS files that simply importing the folder is easier.
  # Theme source: https://github.com/jannikbuscha/firefox-dracula
  home.file."${config.home.homeDirectory}/.mozilla/firefox/${profile0}/chrome" = {
    source = ./chrome;
    recursive = true;
  };
  home.file."${config.home.homeDirectory}/.mozilla/firefox/${profile1}/chrome" = {
    source = ./chrome;
    recursive = true;
  };
  # TODO: nix-colors for chrome/global/colors.css
  # incl. making the background colour dark theme (as it stands, about:blank is a blinding white)
}
