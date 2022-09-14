{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.hardware.cpu.disableMitigations;

in {
  imports = [ ./amd ];

  options.modules.hardware.cpu.disableMitigations = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to disable CPU mitigations.
      '';
    };
  };

  config = mkIf cfg.enable {
    boot.kernelParams = [ "noibrs" "noibpb" "nopti" "nospectre_v2" "nospectre_v1" "l1tf=off" "nospec_store_bypass_disable" "no_stf_barrier" "mds=off" "tsx=on" "tsx_async_abort=off" "mitigations=off" ]; # make-linux-fast-again.com
  };

}
