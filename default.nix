let
  pkgs1 = import ./pkgs.nix;
  pkgs2 = import ./pkgs_jh7100.nix;
in
  pkgs1 // pkgs2
