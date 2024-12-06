{ pkgs, ... }: {
  home.packages = with pkgs; [
    # apps
    sioyek
    google-chrome
    alacritty
    icon-library
    nerdfonts
    discord
    # virtualbox

    # cli tools
    ripgrep
    lazygit
    neofetch
    cmatrix
    railway
    cloc

    # languages
    gcc # C compiler
    clang-tools # CPP lsp
    nil # Nix lsp
    haskellPackages.nixfmt # Nix fmt
    lua-language-server # Lua lsp
    stylua # Lua fmt
    texlab # TeX Lsp
    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-medium # The basics
        cleveref # Smart referencing
        enumitem adjustbox upquote tcolorbox pdfcol environ # Jupyter export
        titling; # Jupyter export
    }) # TeX
    biber # BibLaTex backend
    pyright # Python Lsp
    yapf # Pythin fmt
    rust-analyzer # Rust lsp
    rustfmt # Rust fmt
    rustc # Rust compiler
    cargo # Rust dependecy manager
  ];
}
