{
  programs.yt-dlp = {
    enable = true;

    settings = {
      output = "%(title)s.%(ext)s";
      restrict-filenames = true;
      add-chapters = true;
      continue = true;
      paths = "home:$HOME/Videos";
    };
  };

  home.shellAliases = { yt = "yt-dlp"; };
}
