{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  features = {
    dkwm.enable = true;
    # bspwm.enable = true;
    rime.enable = true;
    picom.enable = true;
    kitty.enable = true;
    dunst.enable = true;
    rofi.enable = true;
    lf.enable = true;
    neovim.enable = true;
    mpd.enable = true;
  };

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  services.syncthing.enable = true;

  nixpkgs = {
    overlays = [
      inputs.neovim-nightly-overlay.overlay
    ] ++ (builtins.attrValues outputs.overlays);
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    username = "philopence";
    homeDirectory = "/home/${config.home.username}";
    packages = with pkgs; [
      gcc
      gnumake
      nodePackages_latest.nodejs
      unzip
      ripgrep
      fd
      maim
      jq
      xclip
      keepassxc
      qmk
      brightnessctl
      trashy
      pcmanfm
      # zathura
      neofetch
      sqlite
      # openssl

      # mongodb
    ];
    pointerCursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
    sessionVariables = {
      GLFW_IM_MODULE = "ibus";
      FLAKE = "${config.home.homeDirectory}/Documents/nix-configuration";
      # NOTE prisma-engines
      # TODO https://github.com/prisma/prisma/issues/17900
      PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
      PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
      PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
      PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
    };
    sessionPath = [
      "$XDG_DATA_HOME/npm/bin"
    ];

    file = {
      ".npmrc".text = ''
        registry = https://registry.npmmirror.com
        prefix = ''${XDG_DATA_HOME}/npm
        cache = ''${XDG_CACHE_HOME}/npm
      '';
      # ".background-image".source = ../extras/nix-catppuccin-mocha.png;
      ".background-image".source = pkgs.fetchurl {

        # url = "https://w.wallhaven.cc/full/o3/wallhaven-o3j1yl.jpg";
        # sha256 = "sha256-z/a1v4wQ0MFil1oluwFnEluKRGV1x+yz4bRSmZWCJFY=";

        # url = "https://w.wallhaven.cc/full/jx/wallhaven-jxyopy.png";
        # sha256 = "sha256-tQTqSltVlQhlfONeyCy2lcSgla2agurO8zB5ghnVZSU=";

        # url = "https://w.wallhaven.cc/full/9d/wallhaven-9dkeqd.png";
        # sha256 = "sha256-VXbsxhPdHc9OgmD/Y1e2IiYIig9x/0+VUxqqAoSeTYQ=";

        # url = "https://w.wallhaven.cc/full/gj/wallhaven-gjyoq7.png";
        # sha256 = "sha256-3vcKZ8x+58Ys5ZlcQMoW2lORILpSAmzrRwzCA1DljcU=";

        url = "https://w.wallhaven.cc/full/l3/wallhaven-l315vy.png";
        sha256 = "sha256-iD2e/KxypPkfi2SfDEt4zc7zRVBaLaVkCcURpNw9GNg=";
      };
    };

  };

  gtk = {
    enable = true;
    font = {
      name = "Sans";
      size = 10;
    };
    theme = {
      package = pkgs.materia-theme;
      name = "Materia-dark-compact";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  xsession = {
    enable = true;
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  programs.chromium = {
    enable = true;
    extensions = [
      { id = "bpoadfkcbjbfhfodiogcnhhhpibjhbnh"; } ## immersive-translate
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } ## ublock-origin
      { id = "aapbdbdomjkkjkaonfhkkikfgjllcleb"; } ## google-translate
      { id = "fmkadmapgofadopljbjfkapdkoienihi"; } ## react-developer-tools
      { id = "lmhkpmbekcpmknklioeibfkpmmfibljd"; } ## redux-devtools
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } ## dark-reader
    ];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
  };

  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = "";
    };
  };

  programs.zoxide.enable = true;
  programs.ripgrep.enable = true;
  programs.bat.enable = true;
  programs.fzf.enable = true;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      character = {
        success_symbol = "[󰈺 ](bold blue)";
        error_symbol = "[󰈺 ](bold red)";
      };
    };
  };

  programs.lazygit.enable = true;

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
    };
  };


  programs.git = {
    enable = true;
    userName = "philopence";
    userEmail = "epcroo@yeah.net";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };


  services.udiskie.enable = true;

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";
}
