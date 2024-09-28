{ config, lib, pkgs, ... }:

{
  home.username = "aaron";
  home.homeDirectory = "/home/aaron";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    xclip
    python3
    pyright
    yapf
    stylua
    nerdfonts
    alacritty
    gnome-tweaks
    gnomeExtensions.hide-top-bar
    gnomeExtensions.color-picker
    ripgrep
    texliveMedium
    lua-language-server
    biber # BibLaTex backend
    texlab # TeX LSP
    sioyek
    nil # nix lsp
    haskellPackages.nixfmt
    lazygit

    libsForQt5.qt5ct
    libsForQt5.breeze-qt5
    libsForQt5.breeze-icons
    noto-fonts-monochrome-emoji
    hyprpaper
    hyprnome
    pavucontrol
  ];

  home.file = { };

  home.sessionVariables = { EDITOR = "nvim"; };

  gtk = {
    enable = true;
    theme.name = "Breeze-Dark";
    cursorTheme.name = "Bibata-Modern-Ice";
    iconTheme.name = "GruvboxPlus";
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
    shellAliases = {
      cfh = "nvim ~/.config/home-manager/home.nix";
      cfn = "nvim ~/.config/nvim/init.lua";
      cfo = "sudo nvim /etc/nixos/configuration.nix";
    };
    initExtra = "neofetch";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      packer-nvim
      lualine-nvim
      rose-pine
      telescope-nvim
      kanagawa-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lua
      nvim-lspconfig
      cmp-buffer
      cmp-path
      cmp-cmdline
      null-ls-nvim
      nvim-web-devicons
      oil-nvim
      alpha-nvim
      vimtex
      lazygit-nvim
      vim-fugitive
    ];
  };
  home.file.".config/nvim/init.lua".source = ./init.lua;
  home.file.".config/sioyek/prefs_user.config".source = ./sioyek.config;

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "none";
        opacity = 0.85;
      };
      shell = { program = "${pkgs.zsh}/bin/zsh"; };
      font = {
        normal = { family = "FiraCode Nerd Font"; };
        size = 14;
      };
      cursor = { style = "Beam"; };
    };
  };

  programs.git = {
    enable = true;
    userName = "Aaron Panaitescu";
    userEmail = "aaronpanaitescu@gmail.com";

    extraConfig = { init.defaultBranch = "main"; };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        HostName github.com 
        User git
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes 
    '';
  };

  programs.home-manager.enable = true;

  qt = { # I like your funny words magic man
    enable = true;
    style.package = pkgs.libsForQt5.breeze-qt5;
    style.name = "breeze-dark";
    platformTheme.name = "kde";
  };

  home.sessionVariables = {
    GTK_THEME = "Breeze-Dark";
    NIXOS_OZONE_WL = 1;
  };
}
