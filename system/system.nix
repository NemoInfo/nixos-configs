{ pkgs, ... }: {
  imports = [
    ./audio.nix
    ./hardware-configuration.nix
    ./hyprland.nix
    ./laptop.nix
    ./locale.nix
  ];

  # nix settings
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  # virtualisation
  programs.virt-manager.enable = true;
  virtualisation = {
    podman.enable = true;
    libvirtd.enable = true;
  };

  # TODO: check if i actually need dconf 
  programs.dconf.enable = true;

  # packages
  environment.systemPackages = with pkgs; [ home-manager neovim git wget ];

  # services
  services = {
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
    };
    printing.enable = true;
    flatpak.enable = true;
  };

  # logind
  services.logind.extraConfig = ''
    HandleLidSwitch=ignore
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
  '';

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = rec {
      allowedTCPPortRanges = [{
        from = 1714;
        to = 1764;
      }];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6BF5-7B00";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/54e2a738-bbb8-4a02-8d4d-869d5204f1a5";
    fsType = "ext4";
  };

  system.stateVersion = "24.05";
}
