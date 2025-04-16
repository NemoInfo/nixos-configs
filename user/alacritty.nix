{ pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "none";
        opacity = 0.85;
      };
      shell.program = "${pkgs.zsh}/bin/zsh";
      font = {
        # normal = { family = "FiraCode Nerd Font"; };
        size = 14;
      };
      cursor = { style = "Beam"; };
    };
  };
}
