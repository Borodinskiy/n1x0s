{ pkgs, config, lib, resourcePath, ... }:
let
  cfg = config.module.purpose.home;

  path = resourcePath + "/dpinspect";
  gameFilter = config.services.zapret.gameFilter.ports;
  paramsBase = [
    "--filter-udp=443" "--hostlist=${path}/list-general.txt" 
    "--dpi-desync=fake" "--dpi-desync-repeats=6" 
    "--dpi-desync-fake-quic=${path}/quic_initial_www_google_com.bin"

    "--new"
    "--filter-udp=50000-50100" "--filter-l7=discord,stun"
    "--dpi-desync=fake" "--dpi-desync-repeats=6"

    "--new"
    "--filter-tcp=80" "--hostlist=${path}/list-general.txt"
    "--dpi-desync=fake,multisplit" "--dpi-desync-autottl=2" "--dpi-desync-fooling=md5sig"

    "--new"
    "--filter-tcp=443" "--hostlist=${path}/list-general.txt"
    "--dpi-desync=fake,fakedsplit" "--dpi-desync-autottl=5" "--dpi-desync-repeats=6" "--dpi-desync-fooling=badseq"
    "--dpi-desync-fake-tls=${path}/tls_clienthello_www_google_com.bin"

    "--new"
    "--filter-udp=443" "--ipset=${path}/ipset-all.txt"
    "--dpi-desync=fake" "--dpi-desync-repeats=6"
    "--dpi-desync-fake-quic=${path}/quic_initial_www_google_com.bin"

    "--new"
    "--filter-tcp=80" "--ipset=${path}/ipset-all.txt"
    "--dpi-desync=fake,multisplit" "--dpi-desync-autottl=2" "--dpi-desync-fooling=md5sig"

    "--new"
    "--filter-tcp=443,${gameFilter}" "--ipset=${path}/ipset-all.txt"
    "--dpi-desync=fake,fakedsplit" "--dpi-desync-autottl=5" "--dpi-desync-repeats=6" "--dpi-desync-fooling=badseq"
    "--dpi-desync-fake-tls=${path}/tls_clienthello_www_google_com.bin"

    "--new"
    "--filter-udp=${gameFilter}" "--ipset=${path}/ipset-all.txt"
    "--dpi-desync=fake" "--dpi-desync-autottl=2" "--dpi-desync-repeats=12" "--dpi-desync-any-protocol=1"
    "--dpi-desync-fake-unknown-udp=${path}/quic_initial_www_google_com.bin"
    "--dpi-desync-cutoff=n3"
  ];
in
{
  options = {
    services.zapret.gameFilter = {
      enable = lib.mkEnableOption "filtering for some ports";
      ports = lib.mkOption {
        default = if config.services.zapret.gameFilter.enable then "1024-6553" else "0";
      };
    };
  };

  config = lib.mkIf cfg {
    # Disable service autostart
    systemd.services.zapret.wantedBy = lib.mkForce [ ];

    services.zapret = {
      enable = true;
      params = paramsBase;
    };

    environment.systemPackages = with pkgs; [
      zapret
    ];
  };
}