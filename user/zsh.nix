{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
    shellAliases = { };
    initExtra = ''
      if [[ -n "$THEME" ]]; then
        ZSH_THEME="$THEME"
      fi
      source $ZSH/oh-my-zsh.sh

      eval "$RUN"
    '';
  };
}
