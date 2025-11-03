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
    (import ./dns.nix {
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
