let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXic308A7rEo7wHowgPem/FTYMGQxsW/jZBmDFPFRog";
in
{
  "vpn.age".publicKeys = [ key ];
  "immich.age".publicKeys = [ key ];
}
