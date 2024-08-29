{ pkgs, ... }:
{

  home.file.".config/git/allowed_signers".text = ''
  '';

  home.packages = with pkgs; [ gh ];

  programs = {
    git = {
      enable = true;

      userEmail = "nrsolichin@gmail.com";
      userName = "Nicholas Solichin";

      includes = [
      ];

      aliases = {
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };

      extraConfig = {
        branch = {
          sort = "-committerdate";
        };
        push = {
          default = "matching";
        };
        pull = {
          rebase = true;
        };
        init = {
          defaultBranch = "main";
        };
      };
    };
  };
}
