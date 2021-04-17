{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-sakuracloud";
  version = "2.8.3";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "sacloud";
    repo = pname;
    rev = "v${version}";
    sha256 = "04v8bh715lhzfx1mwfaqnrvnh73h37ih258wwj2mygpkwkzkimzn";
  };

  vendorSha256 = null;
  postInstall = "mv $out/bin/${pname}{,_v${version}}";
  passthru.provider-source-address = "registry.terraform.io/sacloud/sakuracloud";

  meta = with lib; {
    homepage = "https://docs.usacloud.jp/terraform";
    description = "Terraform provider for SakuraCloud";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
