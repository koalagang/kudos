{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      anki-bin
      # uncomment if you use latex in your Anki cards
      # (texlive.combine { inherit (texlive) scheme-medium dvipng chemformula; })
    ];
    sessionVariables = {
      ANKI_WAYLAND = 1;       # force Anki to use wayland (rather than running through xwayland)
      DISABLE_QT5_COMPAT = 1; # disable qt5 shim and just use qt6
    };
    persistence."/persist/nocow/home/dante".directories = [ ".local/share/Anki2" ];
  };
}
