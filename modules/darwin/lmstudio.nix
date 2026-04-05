{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lmstudio;

in {
  meta.maintainers = [ "rcambrj" ];

  options = {
    services.lmstudio = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the LMStudio headless server.";
      };

      package = mkOption {
        type = types.path;
        default = pkgs.lmstudio;
        description = "The LMStudio package to use.";
      };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = "The host address which the LMStudio server HTTP interface listens to.";
      };

      port = mkOption {
        type = types.port;
        default = 1234;
        example = 3000;
        description = "Which port the LMStudio server listens to.";
      };

      environmentVariables = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          MTL_HUD_ENABLED = "1";
          METAL_DEVICE_WRAPPER_TYPE = "1";
        };
        description = ''
          Set arbitrary environment variables for the LMStudio service.

          Be aware that these are only seen by the LMStudio server (launchd daemon),
          not normal invocations like `lms chat`.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    launchd.user.agents.lmstudio = {
      path = [ config.environment.systemPath ];

      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        ProgramArguments = [ "${cfg.package}/bin/lms" "server" "start" "--port" "${toString cfg.port}" ];

        EnvironmentVariables = cfg.environmentVariables // {
          OLLAMA_HOST = "${cfg.host}:${toString cfg.port}";
        };
      };
    };
  };
}
