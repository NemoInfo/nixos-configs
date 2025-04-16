{ config, pkgs, username, latest, ... }: {
  imports = [
    ./ags.nix
    ./alacritty.nix
    ./git.nix
    ./hyprland.nix
    ./nvim/nvim.nix
    ./packages.nix
    ./theme.nix
    ./zsh.nix
  ];
  home.file.".config/sioyek/prefs_user.config".source = ./sioyek.config;

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      QT_XCB_GL_INTEGRATION = "none";
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      BAT_THEME = "base16";
      EDITOR = "nvim";
    };

    sessionPath = [ "$HOME/.local/bin" ];

    stateVersion = "23.11";
  };

  gtk.gtk3.bookmarks = let home = config.home.homeDirectory;
  in [
    "file://${home}/Documents"
    "file://${home}/Music"
    "file://${home}/Pictures"
    "file://${home}/Videos"
    "file://${home}/Downloads"
    "file://${home}/Projects"
    "file://${home}/.config Config"
  ];

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

}
