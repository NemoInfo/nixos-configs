let
  email = "aaronpanaitescu@gmail.com";
  name = "Aaron";
in {
  programs.git = {
    enable = true;
    userEmail = email;
    userName = name;

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
}
