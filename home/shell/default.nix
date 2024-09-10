{ pkgs, self, ... }:
{
  imports = [
    ./bash.nix
    ./bat.nix
    ./bottom.nix
    ./fzf.nix
    ./git.nix
    ./starship.nix
    ./tmux.nix
    ./vim.nix
    ./zoxide.nix
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
    ripgrep.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  home.packages = with pkgs; [
    age
    nh
    sops
  ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nick/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vi";
  };

  # Aliases, will be inherited by individual shells.
  home.shellAliases = {
    ls = "eza -gl --git --color=automatic";
    tree = "eza --tree";
    cat = "bat";

    ip = "ip --color";
    ipb = "ip --color --brief";

    htop = "btm -b";
    neofetch = "fastfetch";

    ts = "tailscale";
    tst = "tailscale status";
    tsu = "tailscale up --ssh --operator=$USER";
    tsd = "tailscale down";

    speedtest = "curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -";

    hm = "nh home switch ~/nixos-config";
  };
}
