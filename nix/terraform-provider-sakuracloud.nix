{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-sakuracloud";
  version = "2.22.1";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "sacloud";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7ssFroVgMBLGqpB3XHNEN8oxVjRa18njmBG+g7AfOoc=";
  };

  vendorSha256 = "sha256-BUN6lGXM3qkt/2/M786/SlJaJP2UTuk+cbQXe+zuluo=";
  provider-source-address = "registry.terraform.io/sacloud/sakuracloud";
  postInstall = ''
    dir=$out/libexec/terraform-providers/${provider-source-address}/${version}/''${GOOS}_''${GOARCH}
    mkdir -p $dir
    mv $out/bin/* "$dir/terraform-provider-$(basename ${provider-source-address})_${version}"
    rmdir $out/bin
  '';

  meta = with lib; {
    homepage = "https://docs.usacloud.jp/terraform";
    description = "Terraform provider for SakuraCloud";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
