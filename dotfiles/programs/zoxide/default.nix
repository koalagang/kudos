{ config, ... }:

{
  programs.zoxide = {
    enable = true;

    # Enable this for any shell installed and configured by home-manager
    enableBashIntegration    = true;
    enableNushellIntegration = true;
    enableZshIntegration     = true;
    enableFishIntegration    = true;
  };

  # zoxide's configuration is done via environmental variables
  home.sessionVariables = {
    _ZO_DATA_DIR = "${config.xdg.dataHome}/zoxide";
    _ZO_MAXAGE = 10000; # limit number of entries in the database to 1000
    _ZO_RESOLVE_SYMLINKS = 1;
    _ZO_EXCLUDE_DIRS = "$HOME/.*:$XDG_DOCUMENTS_HOME/archive/*:/nix/store/*";
  };
}
