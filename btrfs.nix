{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btrfs-progs
    toybox # for lsattr
  ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [
      "/persist"
      "/nix"
    ];
  };
}
