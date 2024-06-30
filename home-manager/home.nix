{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports =
    [
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  features = {
    dkwm.enable = true;
    rime.enable = true;
    kitty.enable = true;
    neovim.enable = true;
    rofi.enable = true;
    dunst.enable = true;
    picom.enable = true;
  };

  nixpkgs = {
    overlays =
      [
        # inputs.neovim-nightly-overlay.overlays.default
      ]
      ++ (builtins.attrValues outputs.overlays);

    #

    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
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
      go
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
      sqlite
      openssl
      hugo
      stripe-cli
      httpie
      mongosh
      brave
      nitch
      sing-box
      iptables
    ];
    pointerCursor = {
      # package = pkgs.capitaine-cursors;
      # name = "capitaine-cursors";
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 22;
      gtk.enable = true;
      x11.enable = true;
    };
    sessionVariables = {
      GLFW_IM_MODULE = "ibus";
      # FLAKE = "${config.home.homeDirectory}/Documents/nix-configuration";
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
      ".background-image".source = pkgs.fetchurl {

        # cherry blossom cat
        url = "https://w.wallhaven.cc/full/o3/wallhaven-o3j1yl.jpg";
        sha256 = "sha256-z/a1v4wQ0MFil1oluwFnEluKRGV1x+yz4bRSmZWCJFY=";

        # pepe matrix
        # url = "https://w.wallhaven.cc/full/jx/wallhaven-jxyopy.png";
        # sha256 = "sha256-tQTqSltVlQhlfONeyCy2lcSgla2agurO8zB5ghnVZSU=";

        # night girl
        # url = "https://w.wallhaven.cc/full/gj/wallhaven-gjyoq7.png";
        # sha256 = "sha256-3vcKZ8x+58Ys5ZlcQMoW2lORILpSAmzrRwzCA1DljcU=";

        # gruvbox
        # url = "https://w.wallhaven.cc/full/8o/wallhaven-8oky1j.jpg";
        # sha256 = "sha256-4jRQQhny4k89LYF+IRSmUY8ueXl5kKd5w13BWE59qB4=";
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
      name = "Adwaita-dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
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
      {id = "bpoadfkcbjbfhfodiogcnhhhpibjhbnh";} ## immersive-translate
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} ## ublock-origin
      {id = "aapbdbdomjkkjkaonfhkkikfgjllcleb";} ## google-translate
      {id = "fmkadmapgofadopljbjfkapdkoienihi";} ## react-developer-tools
      # { id = "lmhkpmbekcpmknklioeibfkpmmfibljd"; } ## redux-devtools
      # { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } ## dark-reader
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
    # settings = {
    #   character = {
    #     success_symbol = "[$](bold blue)";
    #     error_symbol = "[$](bold red)";
    #   };
    # };
  };

  programs.lazygit.enable = true;

  programs.eza = {
    enable = true;
    git = true;
    icons = true;
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

  services.syncthing.enable = true;

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";
}
