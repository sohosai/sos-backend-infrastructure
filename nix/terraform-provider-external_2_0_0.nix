{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-external";
  version = "2.0.0";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yizxcT3ACjpfVBVrKcUZ4DXkH6BYyJijZpHFh8CPjJs=";
  };

  vendorSha256 = null;
  provider-source-address = "registry.terraform.io/hashicorp/external";
  postInstall = ''
    dir=$out/libexec/terraform-providers/${provider-source-address}/${version}/''${GOOS}_''${GOARCH}
    mkdir -p $dir
    mv $out/bin/* "$dir/terraform-provider-$(basename ${provider-source-address})_${version}"
    rmdir $out/bin
  '';

  meta = with lib; {
    homepage = "https://registry.terraform.io/providers/hashicorp/external/latest";
    description = "Utility provider that exists to provide an interface between Terraform and external programs. Useful for integrating Terraform with a system for which a first-class provider does not exist.";
    license = licenses.mpl20;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
