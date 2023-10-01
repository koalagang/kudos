{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    fira-code
    freefont_ttf
    liberation_ttf
    noto-fonts-emoji
    source-han-serif
    source-han-sans
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
