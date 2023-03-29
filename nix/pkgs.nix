let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/6dc48d1889d90f48831f430f72964021d32f18fe.tar.gz";
    sha256 = "12fr39y06x2s4z2mmnjvpjl8rg5dazqywk08qqx4dch9x0yp7sg1";
  };
in
import nixpkgs {
  overlays = [
    (import ./overlay.nix)
  ];
}
