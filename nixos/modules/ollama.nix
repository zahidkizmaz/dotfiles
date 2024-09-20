{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  environment = {
    systemPackages = with pkgs-unstable; [
      ollama
      nextjs-ollama-llm-ui
    ];
    interactiveShellInit = ''
      alias llms='ollama serve && nextjs-ollama-llm-ui'
    '';
  };
}
