{ pkgs, lib, homedir, rootTarget, ... }:

rec {
  mkDataDir = (groupName: "${homedir}/containers/${groupName}");
  mkService = rec {
    default = (containerName:
      let
        containerService = "docker-${containerName}";
        networkName = "${containerName}_default";
        networkService = "docker-network-${networkName}";
      in { 
        "${containerService}" = container networkService;
        "${networkService}" = network networkName;
      }
    );
    container = (networkService: {
      serviceConfig = restartConfig.unlessStopped;
      after = [ "${networkService}.service" ];
      requires = [ "${networkService}.service" ];
      partOf = [ rootTarget ];
      wantedBy = [ rootTarget ];
    });
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
  restartConfig = {
    unlessStopped = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
  };
}