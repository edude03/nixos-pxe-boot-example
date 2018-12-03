{ config, lib, pkgs, ... }:

{
  # Settings for Nix

  nix.buildCores = 8;
  nix.useSandbox = false;

  # hardcode the settings for the eth0 interface
  networking.interfaces.eth0 = {
    ipv4.addresses = [ { address = "192.168.3.1"; prefixLength = 24; }];
  };

  networking.nat.enable = true;
  networking.nat.externalInterface = "eth1";
  networking.nat.internalInterfaces = [ "eth0" ];

  # Disable interface renaming so we can have eth0
  boot.kernelParams = [ "net.ifnames=0" ];

  # Enable NFS for Installer
  services.nfs.server = {
    enable = true;
    exports = ''
      /srv/nixos/nfsroot 192.168.3.0/24(async,ro,no_subtree_check,no_root_squash)
    '';
  };

  services.nfs.server.statdPort = 4000;
  services.nfs.server.mountdPort = 4002;
  services.nfs.server.lockdPort = 4001;
  services.nfs.server.createMountPoints = true;
}
