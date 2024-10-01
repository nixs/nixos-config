{
  config,
  username,
  hostname,
  ...
}: {
  programs.bash.enable = false;

  home.sessionVariables = {
    FLAKE_CONFIG_URI = "${config.home.homeDirectory}/nixos-config#homeConfigurations.\"${username}@${hostname}\"";
  };
}
