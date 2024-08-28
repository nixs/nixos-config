{ pkgs, self, ... }:
{
  imports = [
    ./bash.nix
    ./bat.nix
    ./bottom.nix
    ./git.nix
    ./starship.nix
    ./tmux.nix
    ./vim.nix
    ./zsh.nix
  ];

  catppuccin = {
    flavor = "macchiato";
    accent = "blue";
    #size = "standard";
  };

  programs = {
    eza.enable = true;
    git.enable = true;
    gpg.enable = true;
    home-manager.enable = true;
    jq.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  home.packages = with pkgs; [
    age
    sops
  ];
}
