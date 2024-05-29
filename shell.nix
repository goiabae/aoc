{ pkgs ? import <nixpkgs-unstable> {} }:
with pkgs; mkShell {
  packages = [
    aoc-cli
    lua
    luajit
    sumneko-lua-language-server
    stylua
  ];

  hardeningDisable = [ "fortify" ];
}
