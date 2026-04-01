{ version ? "2.1.87"
, hash ? "sha256-tRrJ1UuolwI9d7ZOvBml0xJ9yZ3u57vGBfvF69artI8="
,
}:
(final: prev: {
  # claude-code is now a self-contained bundle with zero npm dependencies
  claude-code = prev.stdenv.mkDerivation {
    pname = "claude-code";
    inherit version;

    src = prev.fetchzip {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-jorpY6ao1YgkoTgIk1Ae2BQCbqOuEtwzoIG36BP5nG4=";
      # inherit hash;
    };

    nativeBuildInputs = [ prev.makeWrapper ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/claude-code $out/bin
      cp -r . $out/lib/claude-code/
      makeWrapper ${prev.nodejs}/bin/node $out/bin/claude \
        --add-flags "$out/lib/claude-code/cli.js"
      runHook postInstall
    '';

    meta = {
      description = "Agentic coding tool that lives in your terminal";
      homepage = "https://github.com/anthropics/claude-code";
      license = prev.lib.licenses.unfree;
      mainProgram = "claude";
    };
  };
})
