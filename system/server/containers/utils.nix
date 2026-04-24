{ pkgs, lib, rootTarget, ... }:

{
  mkService = {
    network = (networkName: {
      path = [ pkgs.docker ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "docker network rm -f ${networkName}";
      };
      script = ''
        docker network inspect ${networkName} || docker network create ${networkName}
      '';
      partOf = [ rootTarget ];
      wantedBy = [ rootTarget ];
    });
  };
}