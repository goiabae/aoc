{ pkgs ? import <nixpkgs> {} }:
with pkgs; mkShell {
  packages = [
    aoc-cli
    lua
    luajit
    lua-language-server
    stylua
  ];

  hardeningDisable = [ "fortify" ];

  shellHook = ''
    export LUA_PATH="$LUA_PATH;/home/goiabae/source/aoc/lib/?.lua"
  '';
}
