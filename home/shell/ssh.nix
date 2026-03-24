{
  lib,
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      compression = true;
      checkHostIP = false;

      # Keep Alive & Connection
      extraOptions = {
        "ConnectTimeout" = "60";
        "ConnectionAttempts" = "2";
        "ServerAliveInterval" = "60";
        "ServerAliveCountMax" = "4";
      };

      # SSH Multiplexing
      controlMaster = "auto";
      controlPath = "~/.ssh/%C";
      controlPersist = "yes";
    };
  };
}
