{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.TEMPLATE;
in {
  options.features.TEMPLATE = {
    enable = mkEnableOption "TEMPLATE";
  };

  config = mkIf cfg.enable {};
}
