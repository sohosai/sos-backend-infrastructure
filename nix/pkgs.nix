let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/55eed1ef7be968feed5bdc6c4d354f5cc9955696.tar.gz";
    sha256 = "0ma8bnlldl1viypgwqplqbb477n8pras48cji7ifq92pqvkx4z3v";
  };
in
import nixpkgs {
  overlays = [
    (import ./overlay.nix)
  ];
}
