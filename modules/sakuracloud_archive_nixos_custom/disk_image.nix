{ pkgs ? import ../../nix/pkgs.nix
, useKvm ? true
, configFileText
, rootPath
, importsJson
, contentTextsJson
}:
let
  contents = map
    (content: {
      inherit (content) target;
      source = pkgs.writeText "content" content.content;
      mode = content.mode or null;
      user = content.user or null;
      group = content.group or null;
    })
    (builtins.fromJSON contentTextsJson);
  configFile = pkgs.writeText "configuration.nix" configFileText;
  toImportPath = p: rootPath + ("/" + p);
in
import ../../nix/disk {
  inherit pkgs contents useKvm;
  additionalImports = [ (builtins.toPath configFile) ]
    ++ map toImportPath (builtins.fromJSON importsJson);
}
