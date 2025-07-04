{
  version ? "1.0.56",
  hash ? "sha256-q/17LfP5MWeKpt8akPXwMvkZ6Qhc+9IGpM6N34JuExY=",
}:
let
  mkFetchUrl =
    pkgVersion: "https://registry.npmjs.org/@anthrophic-ai/claude-code/-/claude-code-${pkgVersion}.tgz";
  mkOverriddenPkg =
    pkg: fetchzip:
    pkg.overrideAttrs (
      final: prev: {
        inherit version;
        src = fetchzip {
          inherit hash;
          url = mkFetchUrl version;
        };

        npmDepsHash = "";
      }
    );
in
(final: prev: {
  claude-code = mkOverriddenPkg prev.claude-code prev.fetchzip;
})
