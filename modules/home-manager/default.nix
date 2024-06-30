# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  # bspwm = import ./bspwm;
  picom = import ./picom;
  # lf = import ./lf;
  # mpd = import ./mpd;
  dunst = import ./dunst;
  dkwm = import ./dkwm;
  rime = import ./rime;
  kitty = import ./kitty;
  neovim = import ./neovim;
  rofi = import ./rofi;
}
