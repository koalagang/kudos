{ config, ... }:

{
  xdg = {
    enable = true;

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
      # By setting these to an existing directory,
      # we can effectively set xdg not to make them
      # (there is no option to disable them, not even by using an empty string)
      music = "${config.home.homeDirectory}";
      publicShare = "${config.home.homeDirectory}";
      templates = "${config.home.homeDirectory}";
    };

    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  home.sessionVariables = {
    XDG_DESKTOP_DIR = "${config.xdg.userDirs.desktop}";
    XDG_DOCUMENTS_DIR = "${config.xdg.userDirs.documents}";
    XDG_DOWNLOAD_DIR = "${config.xdg.userDirs.download}";
    XDG_PICTURES_DIR = "${config.xdg.userDirs.pictures}";
    XDG_VIDEOS_DIR = "${config.xdg.userDirs.videos}";
    XDG_CACHE_HOME = "${config.xdg.cacheHome}";
    XDG_CONFIG_HOME = "${config.xdg.configHome}";
    XDG_DATA_HOME = "${config.xdg.dataHome}";
    XDG_STATE_HOME = "${config.xdg.stateHome}";
  };
}
