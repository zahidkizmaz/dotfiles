{
  pkgs,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
  llm-agents-pkgs = inputs.llm-agents.packages.${system};

  # Upstream test suite is flaky on macOS (Linux socket assumptions).
  ha-mcp = pkgs-unstable.ha-mcp.overridePythonAttrs {
    doCheck = !pkgs.stdenv.hostPlatform.isDarwin;
  };
in
{
  environment = {
    systemPackages =
      (with llm-agents-pkgs; [
        opencode
        pi
        rtk
      ])
      ++ [ ha-mcp ]
      ++ (with pkgs-unstable; [
        infisical
        ollama
      ]);
  };
}
