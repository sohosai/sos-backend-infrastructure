{ lib, config, ... }:

with lib;
let
  cfg = config.sos21-production-server;
in
{
  options = {
    sos21-production-server = {
      switch = mkOption {
        type = types.submodule {
          options = {
            network = mkOption {
              type = types.str;
            };

            ipAddress = mkOption {
              type = types.str;
            };

            prefixLength = mkOption {
              type = types.int;
            };
          };
        };
      };

      router = mkOption {
        type = types.submodule {
          options = {
            network = mkOption {
              type = types.str;
            };

            ipAddress = mkOption {
              type = types.str;
            };

            prefixLength = mkOption {
              type = types.int;
            };

            gateway = mkOption {
              type = types.str;
            };
          };
        };
      };

      rootAuthorizedKeys = mkOption {
        type = types.listOf types.str;
      };

      adminUser = mkOption {
        type = types.submodule {
          options = {
            authorizedKeys = mkOption {
              type = types.listOf types.str;
            };

            name = mkOption {
              type = types.str;
            };

            hashedPassword = mkOption {
              type = types.str;
            };
          };
        };
      };
    };
  };

  config = {
    services.openssh = {
      permitRootLogin = "prohibit-password";
      passwordAuthentication = false;
      challengeResponseAuthentication = false;
    };

    users.users.root = {
      hashedPassword = null;
      openssh.authorizedKeys.keys = cfg.rootAuthorizedKeys;
    };
    users.users."${cfg.adminUser.name}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword = "${cfg.adminUser.hashedPassword}";
      openssh.authorizedKeys.keys = cfg.adminUser.authorizedKeys;
    };

    networking.dhcpcd.enable = false;
    networking.defaultGateway = {
      address = "${cfg.router.gateway}";
      interface = "ens3";
    };
    networking.interfaces.ens3 = {
      useDHCP = false;
      ipv4 = {
        routes = [
          {
            address = cfg.router.network;
            inherit (cfg.router) prefixLength;
          }
        ];
        addresses = [
          {
            address = cfg.router.ipAddress;
            inherit (cfg.router) prefixLength;
          }
        ];
      };
    };
    networking.interfaces.ens4 = {
      useDHCP = false;
      ipv4 = {
        routes = [
          {
            address = cfg.switch.network;
            inherit (cfg.switch) prefixLength;
          }
        ];
        addresses = [
          {
            address = cfg.switch.ipAddress;
            inherit (cfg.switch) prefixLength;
          }
        ];
      };
    };
  };
}
