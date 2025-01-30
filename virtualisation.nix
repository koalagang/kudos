{ pkgs, lib, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      # BIOS firmware
      ovmf = {
        enable = true;
        packages = [ (pkgs.OVMF.override { secureBoot = true; }).fd ];
      };
    };
  };
  # GUI front-end
  programs.virt-manager.enable = true;

  # do not activate libvirtd service on startup (it will activate when launching virt-manager anyway)
  systemd.services.libvirtd.wantedBy = lib.mkForce [];
  systemd.services.libvirt-guests.wantedBy = lib.mkForce [];

  # add user to the libvirtd group
  users.users.dante.extraGroups = [ "libvirtd" ];

  # persist VMs with nodatacow
  environment.persistence."/persist/nocow/system".directories = [ "/var/lib/libvirt" ];
}
