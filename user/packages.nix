{ pkgs, ... }: {
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
    gcc # C compiler
    nil # Nix lsp
    haskellPackages.nixfmt # Nix fmt
    lua-language-server # Lua lsp
    stylua # Lua fmt
    texlab # TeX Lsp
    texliveMedium # TeX
    biber # BibLaTex backend
    pyright # Python Lsp
    yapf # Pythin fmt
    rust-analyzer # Rust lsp
    rustfmt # Rust fmt
    rustc # Rust compiler
    cargo # Rust dependecy manager
  ];
}
