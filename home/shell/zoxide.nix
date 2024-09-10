{ pkgs, lib, ... }:
{
  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      #options = [ "--cmd cd" ];
    };
  };

  home.shellAliases = lib.mkAfter {
    cd = "z"; 
  };
}
