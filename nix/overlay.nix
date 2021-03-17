self: super: {
  terraform-providers = super.terraform-providers // {
    sakuracloud = super.callPackage ./terraform-provider-sakuracloud.nix { };
  };
}
