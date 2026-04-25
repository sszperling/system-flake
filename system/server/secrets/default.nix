{ agenix, homedir, ... }:

{
  environment.systemPackages = [ agenix.packages.x86_64-linux.default ];

  age = {
    identityPaths = [ "${homedir}/.ssh/id_github" ];
    secrets = {
      vpn = {
        file = ./vpn.age;
      };
      immich = {
        file = ./immich.age;
      };
    };
  };
}
