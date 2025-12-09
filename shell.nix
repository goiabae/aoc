{ pkgs ? import <nixpkgs> {} }:
with pkgs; mkShell {
  packages = [
    lua
    luajit
    lua-language-server
    stylua
  ];

  hardeningDisable = [ "fortify" ];

  shellHook = ''
    export LUA_PATH="/home/goiabae/source/aoc/lib/?.lua;$LUA_PATH"
  '';
}
