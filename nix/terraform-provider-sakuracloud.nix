{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-sakuracloud";
  version = "2.7.1";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "sacloud";
    repo = pname;
    rev = "v${version}";
    sha256 = "04czwq1ks29pnranxjlms3dbbrzrcx90vw8f6916yb7c2xnas53j";
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
