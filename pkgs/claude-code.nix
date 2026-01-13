{
  version ? "2.1.3",
  hash ? "sha256-IF0ZQ2ddjtoQ6J9lXaqrak9Wi6pCCIqnMu2l8woHZIs=",
}: let
  mkFetchUrl = pkgVersion: "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${pkgVersion}.tgz";
  mkOverriddenPkg = pkg: fetchzip:
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
in (final: prev: {
  claude-code = mkOverriddenPkg prev.claude-code prev.fetchzip;
})
