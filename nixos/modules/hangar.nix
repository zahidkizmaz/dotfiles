{ inputs, system, ... }:
{
  environment.systemPackages = [ inputs.hangar.packages.${system}.default ];
}
