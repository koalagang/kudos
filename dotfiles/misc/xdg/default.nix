{ config, ... }:

{
  xdg = {

    #mime.enable = true;
    #mimeapps = {
    #  enable = true;
    #  # TODO
    #};

    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      extraConfig = {
        XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
        XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      };
      # By setting these to an existing directory, we can effectively disable them
      # (there is no option to disable them, not even by using an empty string)
      music = "${config.home.homeDirectory}";
      publicShare = "${config.home.homeDirectory}";
      templates = "${config.home.homeDirectory}";
    };
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  home.sessionVariables = {
    XDG_DESKTOP_HOME = "${config.xdg.userDirs.desktop}";
    XDG_DOCUMENTS_HOME = "${config.xdg.userDirs.documents}";
    XDG_DOWNLOAD_HOME = "${config.xdg.userDirs.download}";
    XDG_PICTURES_HOME = "${config.xdg.userDirs.pictures}";
    XDG_VIDEOS_HOME = "${config.xdg.userDirs.videos}";
    XDG_CONFIG_HOME = "${config.xdg.userDirs.extraConfig.XDG_CONFIG_HOME}";
    XDG_CACHE_HOME = "${config.xdg.userDirs.extraConfig.XDG_CACHE_HOME}";
    XDG_DATA_HOME = "${config.xdg.dataHome}";
    XDG_STATE_HOME = "${config.xdg.stateHome}";
  };
}
