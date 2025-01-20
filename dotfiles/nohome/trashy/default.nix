{ pkgs, ... }:

{
  home = {
    shellAliases = {
      tp = "${pkgs.trashy}/bin/trash put";
      tl = "${pkgs.trashy}/bin/trash list";
      tre = "${pkgs.trashy}/bin/trash restore";
      te = "${pkgs.trashy}/bin/trash empty --all";
      # follow this with the ID of the trashed file to delete a specific one
      trm = "${pkgs.trashy}/bin/trash empty";
      # search the trash and *restore* the file(s) you select (can select multiple by using shift+tab)
      trf = "${pkgs.trashy}/bin/trash list | ${pkgs.fzf}/bin/fzf --multi | ${pkgs.gawk}/bin/awk '{ print $NF }' | ${pkgs.findutils}/bin/xargs ${pkgs.trashy}/bin/trash restore --match=exact";
      # search the trash and *delete* the file(s) you select (can select multiple by using shift+tab)
      tef = "${pkgs.trashy}/bin/trash list | ${pkgs.fzf}/bin/fzf --multi | ${pkgs.gawk}/bin/awk '{ print $NF }' | ${pkgs.findutils}/bin/xargs ${pkgs.trashy}/bin/trash empty --match=exact";
    };
    persistence."/persist/nocow/home/dante".directories = [ ".local/share/Trash" ];
  };
}

