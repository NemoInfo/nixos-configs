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

  users.users.${username} = {
    isNormalUser = true;
    extraGroups =
      [ "audio" "libvirtd" "nixosvmtest" "networkmanager" "video" "wheel" ];
    shell = pkgs.zsh; # TODO: maybe remove
  };
  programs.zsh.enable = true;

#   home-manager = {
#     backupFileExtension = "backup";
#     useGlobalPkgs = true;
#     useUserPackages = true;
#     extraSpecialArgs = { inherit inputs; };
#     users.${username} = {
#       home.username = username;
#       home.homeDirectory = "/home/${username}";
#       imports = [
#         ../user/home.nix # x
#       ];
#     };
#   };
}
