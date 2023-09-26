{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;

    config = {
      screenshot-directory = "~/Pictures";
      ao = "pipewire,pulse,alsa";
    };

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
    };

    scripts = [ pkgs.mpvScripts.mpris ];
  };
}
