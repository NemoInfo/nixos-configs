{ pkgs, latest, ... }: {
  home.packages = let
    pkgList = with pkgs; [
      # apps
      sioyek
      google-chrome
      alacritty
      icon-library
      nerdfonts
      discord
      inkscape
      obs-studio
      vlc
      # bottles
      # virtualbox

      # cli tools
      ripgrep
      lazygit
      neofetch
      cmatrix
      railway
      cloc
      tree

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
          glossaries glossaries-english glossaries-extra pdfcomment datetime2
          datetime2-english zref marginnote soulpos svg transparent xcolor # .
          catchfile appendix titling;
      }) # TeX
      biber # BibLaTex backend
      pyright # Python Lsp
      yapf # Pythin fmt
      rust-analyzer # Rust lsp
      rustfmt # Rust fmt
      rustc # Rust compiler
      cargo # Rust dependecy manager
      cudatoolkit
    ];
    latestList = with latest.legacyPackages.x86_64-linux; [
      typst # f*ck latex
      tinymist
    ];
  in pkgList ++ latestList;
}
