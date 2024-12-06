{ inputs, username, pkgs, ... }: {
  imports = [
    ./audio.nix
    ./hardware-configuration.nix
    ./hyprland.nix
    ./laptop.nix
    ./locale.nix
    ./system.nix
    ./nautilus.nix
  ];
  hyprland.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups =
      [ "audio" "libvirtd" "nixosvmtest" "networkmanager" "video" "wheel" "vboxusers"];
    shell = pkgs.zsh; # TODO: maybe remove
  };
  programs.zsh.enable = true;
}
