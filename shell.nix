{ pkgs ? import <nixpkgs-unstable> {} }:
with pkgs; mkShell {
  packages = [ aoc-cli lua luajit ];

  hardeningDisable = [ "fortify" ];
}
