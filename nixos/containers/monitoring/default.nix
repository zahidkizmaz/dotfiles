{
  inputs,
  user,
  stateVersion,
  localAddress,
  hostAddress,
  ...
}:
{
  imports = [
    (import ./grafana.nix {
      inherit
        stateVersion
        inputs
        user
        localAddress
        hostAddress
        ;
    })
  ];
}
