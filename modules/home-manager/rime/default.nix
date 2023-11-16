{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.rime;
in

{
  options.features.rime = {
    enable = mkEnableOption "Rime Input Method Engine";
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-rime ];
    };
    xdg.dataFile = {
      "fcitx5/rime/zhwiki.dict.yaml".source = pkgs.fetchurl {
        url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.4/zhwiki-20230823.dict.yaml";
        sha256 = "sha256-2cx+enR+2lK0o+pYoP8CQg3qd2+nBpQVZhDj4pEPQjU=";
      };

      "fcitx5/rime/moegirl.dict.yaml".source = pkgs.fetchurl {
        url = "https://github.com/outloudvi/mw2fcitx/releases/download/20230814/moegirl.dict.yaml";
        sha256 = "sha256-Wl7a/LXP2zGGKjWcm1IjiljS+EyODDOQX2D9wuwYckQ=";
      };

      "fcitx5/rime/default.custom.yaml".text = ''
        patch:
          ascii_composer:
            switch_key:
              Shift_L: noop
              Shift_R: commit_code
          key_binder:
            bindings:
              - {accept: Left, send: Page_Up, when: has_menu}
              - {accept: Right, send: Page_Down, when: has_menu}
              - {accept: "Release+Escape", toggle: ascii_mode, when: always}
      '';

      "fcitx5/rime/luna_pinyin.custom.yaml".text = ''
        patch:
          "switches/@0/reset": 1
          "switches/@2/reset": 1
          "recognizer/patterns/reverse_lookup":
            "translator/dictionary": extended
          "punctuator/half_shape/=":
            "'": {pair: ["「", "」"]}
            "\"": {pair: ["『", "』"]}
      '';

      "fcitx5/rime/extended.dict.yaml".text = ''
        ---
        name: extended
        version: "0.0.1"
        sort: by_weight
        use_preset_vocabulary: true
        import_tables:
          - luna_pinyin
          - zhwiki
          - moegirl
        ...
      '';
    };
  };
}
