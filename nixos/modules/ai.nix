{ pkgs, inputs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
  llm-agents-pkgs = inputs.llm-agents.packages.${system};
in
{
  environment = {
    systemPackages =
      (with llm-agents-pkgs; [
        opencode
        rtk
      ])
      ++ (with pkgs-unstable; [
        ollama
        ha-mcp
      ]);
  };
}
