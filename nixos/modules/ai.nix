{
  pkgs,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
  llm-agents-pkgs = inputs.llm-agents.packages.${system};

  infisicalVersion = "0.44.11";
  infisicalSuffix = {
    x86_64-linux = "linux_amd64";
    aarch64-linux = "linux_arm64";
    aarch64-darwin = "darwin_arm64";
  };
  infisicalHash = {
    x86_64-linux = "sha256-1ffqa56SOOFQaV2v5vBsC6oGpuHdlC0SiWx5fDhqgJI=";
    aarch64-linux = "sha256-YnnJRloa8KBuEI/KnuTfYY+JjLxdXZ1AS+/D7EpTMsM=";
    aarch64-darwin = "sha256-bX5gU/wl8uI4y808+zhoUi9CTJ80oH1RN5M2YKK0D54=";
  };
  infisical = pkgs-unstable.infisical.overrideAttrs (_: {
    version = infisicalVersion;
    src = pkgs.fetchurl {
      name = "cli_${infisicalVersion}_${infisicalSuffix.${system}}.tar.gz";
      url = "https://github.com/Infisical/cli/releases/download/v${infisicalVersion}/cli_${infisicalVersion}_${infisicalSuffix.${system}}.tar.gz";
      hash = infisicalHash.${system};
    };
  });
in
{
  environment = {
    systemPackages =
      (with llm-agents-pkgs; [
        opencode
        pi
        rtk
      ])
      ++ [
        infisical
      ]
      ++ (with pkgs-unstable; [
        ha-mcp
        ollama
      ]);
  };
}
