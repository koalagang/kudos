{ config, ... }:

{
  programs.yt-dlp = {
    enable = true;

    settings = {
      output = "%(title)s.%(ext)s";
      restrict-filenames = true;
      add-chapters = true;
      continue = true;
      paths = "home:${config.xdg.userDirs.videos}";
    };
  };

  home.shellAliases.yt = "yt-dlp";
}
