self: super: {
  terraform-providers = super.terraform-providers // {
    sakuracloud = super.callPackage ./terraform-provider-sakuracloud.nix { };
    external = super.callPackage ./terraform-provider-external_2_0_0.nix { };
  };
}
