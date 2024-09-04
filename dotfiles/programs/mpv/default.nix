{ pkgs, config, ... }:

{
  programs.mpv = {
    enable = true;

    config.screenshot-directory = "~/Pictures/mpv";

    bindings = {
      R = "sub-reload 1";
      h = "seek -5";
      l = "seek 5";
      H = "seek -15";
      L = "seek 15";
      b = "seek -50";
      w = "seek 50";
      k = "add volume 10";
      j = "add volume -10";
      J = "add video-zoom +1";
      K = "add video-zoom -1";
      u = "revert-seek";
      S = "cycle sub";
      # Copy URL (if video) or path (if file) to clipboard.
      # I know. The amount of backslashes here is crazy but you've got to escape loads of stuff.
      # The input.conf line will look like this:
      # C run "sh" "-c" "printf \"${path}\" | xclip -i -selection clipboard"; show-text "${path} copied to clipboard"
      C = "run \"sh\" \"-c\" \"printf \\\"\${path}\\\" | xclip -i -selection clipboard\"; show-text \"\${path} copied to clipboard\"";
    };

    scripts = [ pkgs.mpvScripts.mpris ];
  };

  # A FOSS, mpv-based video player for studying Japanese
  # https://ripose-jp.github.io/Memento/
  home = {
    packages = [ pkgs.memento ];
    # TODO: figure out how to do this in a pure way
    # Use regular mpv's config for memento's mpv back-end too
    #file."${config.xdg.configHome}/memento" = {
    #  source = "${config.xdg.configHome}/mpv";
    #  recursive = true;
    #};
  };
}
