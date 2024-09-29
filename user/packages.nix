{pkgs, ...}:
{
  home.packages = with pkgs; [
    # apps
    sioyek
    google-chrome
    alacritty
    icon-library
    nerdfonts

    # cli tools
    ripgrep
    lazygit
    neofetch

    # languages
    nil                     # Nix lsp
    haskellPackages.nixfmt  # Nix fmt
    lua-language-server     # Lua lsp
    stylua                  # Lua fmt
    texlab                  # TeX Lsp
    texliveMedium           # TeX
    biber                   # BibLaTex backend
    pyright                 # Python Lsp
    yapf                    # Pythin fmt
  ];
}
