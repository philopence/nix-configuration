{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.neovim;
in

{
  options.features.neovim = {
    enable = mkEnableOption "TEMPLATE";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraPackages = with pkgs; [
        stylua
        nixpkgs-fmt
        fswatch # https://github.com/neovim/neovim/pull/27347
        eslint_d
        prettierd
        lua-language-server
        nodePackages_latest.typescript-language-server
        nodePackages_latest."@prisma/language-server"
        vscode-langservers-extracted
        tailwindcss-language-server
        typescript
        # codeium
      ];
    };

    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.FLAKE}/extras/nvim";
  };
}
