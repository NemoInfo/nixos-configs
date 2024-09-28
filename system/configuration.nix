# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, username, ... }:

{

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

  # user
  users.users.${username} = {
    isNormalUser = true;
    extraGroups =
      [ "audio" "libvirtd" "nixosvmtest" "networkmanager" "video" "wheel" ];
    shell = pkgs.zsh; # TODO: maybe remove
  };

  # Enable hyperland
  #   services.xserver.displayManager.gdm.wayland = true;
  # 
  #   programs.hyprland = {
  #     enable = true;
  #     xwayland.enable = true;
  #   };
  # 
  #   # Enable the GNOME Desktop Environment.
  #   services.xserver.displayManager.gdm.enable = true;
  #   services.xserver.desktopManager.gnome.enable = true;
  # 
  #   xdg.portal = {
  #     enable = true;
  #     extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  #   };
  # 
  #   console.useXkbConfig = true;
  #   services.xserver.xkb = {
  #     layout = "gb";
  #     variant = "";
  #     options = "ctrl:swapcaps";
  #   };
  # 
  #   # Enable touchpad support (enabled default in most desktopManager).
  #   services.libinput.enable = true;
  # 
  #   programs.mtr.enable = true;
  #   programs.gnupg.agent = {
  #     enable = true;
  #     enableSSHSupport = true;
  #   };
  # 
  #   # Enable the OpenSSH daemon.
  #   services.openssh.enable = true;
  # 
  #  programs.zsh.enable = true;

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

  system.stateVersion = "24.05"; # Did you read the comment?
}
