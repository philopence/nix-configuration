{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops

    ./hardware-configuration.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  features.xserver.enable = true;

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      experimental-features = "nix-command flakes";
      substituters = [
        "https://nix-community.cachix.org"
        # "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
    };
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config = {
      allowUnfree = true;
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      "philopence" = import ../home-manager/home.nix;
    };
  };


  sops = {
    age.sshKeyPaths = [ "/nix/persistent/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ../extras/secrets.yaml;
    secrets = {
      "wireless.env" = { };
      "philopence".neededForUsers = true;
    };
  };

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;
    users = {
      # mkpasswd -m SHA-512 -s "<PASSWD>"
      root = {
        initialHashedPassword = "$6$aXXcWWvfrOnLVjBF$38D8mmf.vHgWJFpOo7NHePs7To/1ftYU/hYzeE1ND2./7o.KLQsNplFn0mUoQFk9u72MKAHlt9Altb71jE6Te/";
      };
      philopence = {
        # initialHashedPassword = "$6$3hTuLWjxU8H5MYyN$CUR97rhioR5X7CNvMKDWvQmN9EupnRSFL1N4A1SxDLqOdrjHuRxHTv7nK4YmeUr8LuQq/E75JNZZdBRpWu7la/";
        hashedPasswordFile = config.sops.secrets."philopence".path;
        isNormalUser = true; # useDefaultShell = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keyFiles = [ ../extras/user_philopence.pub ];
      };
    };
  };

  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [ ];
    variables = {
      SOPS_AGE_KEY_FILE = "/run/media/philopence/SanDisk/user_philopence_keys.txt";
    };
    persistence."/nix/persistent" = {
      directories = [
        "/etc/v2raya"
        "/etc/ssh"
      ];
      files = [ ];
      users."philopence" = {
        directories = [
          "Desktop"
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "Public"
          "Templates"
          "Videos"
          ".cache"
          ".config"
          ".local"
          ".ssh"
        ];
        files = [ ];
      };
    };
  };

  networking = {
    hostName = "nixos";
    firewall.enable = true;
    wireless = {
      enable = true;
      environmentFile = "/run/secrets/wireless.env";
      networks = {
        "ERROR" = {
          hidden = true;
          pskRaw = "@ERROR@";
        };
        "hotspot" = {
          pskRaw = "6589d759a80278d2fd8b3d105934f19b877fafe3896e0c4632632dd846635f7e";
        };
      };
    };
  };

  # networking.proxy.default = "192.168.0.100:2333";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  services.v2raya.enable = true;

  time.timeZone = "Asia/Shanghai";

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      sarasa-gothic
      lxgw-neoxihei
      lxgw-wenkai
      recursive
      cascadia-code
      jost
      ibm-plex
      # ✿
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Jost*" "LXGW Neo XiHei" "LXGW WenKai" "Sarasa Mono SC" ];
        sansSerif = [ "Jost*" "LXGW Neo XiHei" "LXGW WenKai" "Sarasa Mono SC" ];
        monospace = [ "LXGW Neo XiHei" "LXGW WenKai" "Sarasa Term SC" ];
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <!-- settings go here -->
          <match target="pattern">
            <test qual="any" name="family" compare="eq"><string>Arial</string></test>
            <edit name="family" mode="assign" binding="same"><string>Jost*</string></edit>
          </match>
          <match target="pattern">
            <test qual="any" name="family" compare="eq"><string>Helvetica</string></test>
            <edit name="family" mode="assign" binding="same"><string>Jost*</string></edit>
          </match>
          <match target="pattern">
            <test qual="any" name="family" compare="eq"><string>Noto Sans</string></test>
            <edit name="family" mode="assign" binding="same"><string>Jost*</string></edit>
          </match>
        </fontconfig>
      '';
    };
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
    ## 1. initialize SSH-KEY
    ## 2. recover through impermanence
    ## 3. disable hostKeys option to fix SOPS
    hostKeys = [ ];
    # OR
    ## hostKeys = [
    ##   {
    ##     bits = 4096;
    ##     path = "/nix/persistent/etc/ssh/ssh_host_rsa_key";
    ##     type = "rsa";
    ##   }
    ##   {
    ##     path = "/nix/persistent/etc/ssh/ssh_host_ed25519_key";
    ##     type = "ed25519";
    ##   }
    ## ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
  };

  services.udisks2.enable = true;

  programs.dconf.enable = true;

  programs.fish.enable = true;

  programs.git.enable = true;

  programs.neovim.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      glibc # NOTE codeium language_server_linux_x64
    ];
  };

  hardware.keyboard.qmk.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
