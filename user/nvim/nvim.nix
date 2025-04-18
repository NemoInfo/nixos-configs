{ pkgs, latest, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = let
      old = with pkgs.vimPlugins; [
        packer-nvim
        lualine-nvim
        rose-pine
        telescope-fzf-native-nvim
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
        rust-tools-nvim
        coc-ltex
        julia-vim
        typst-vim
        nvim-ufo
        nvim-treesitter.withAllGrammars
      ];
      new = with latest.legacyPackages.x86_64-linux.vimPlugins; [
        typst-preview-nvim
        typst-vim
      ];
    in old ++ new;
  };

  home.file.".config/nvim/init.lua".source = ./init.lua;
}
