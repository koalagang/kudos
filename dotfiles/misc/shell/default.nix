# NOTE: if you're looking for my shell of choice, you're in the wrong place.
# My zsh configuration is in programs/zsh.
# This config here just consists of my general shell-neutral stuff,
# i.e. aliases and functions.
{
  imports = [
    ./aliasrc.nix
    ./functionrc.nix
    ./variables.nix
  ];
}
