{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;

    config.screenshot-directory = "~/Pictures";

    bindings = {
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
}
