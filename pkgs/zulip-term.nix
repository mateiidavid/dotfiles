(final: prev: {
  zulip-term = prev.zulip-term.overrideAttrs {
    version = "0.7.0-unstable-2026-01-27";
    src = prev.fetchzip {
      url = "https://github.com/zulip/zulip-terminal/archive/6a799870eccc00d612e25ff881d18f4ff66d92fa.tar.gz";
      hash = "sha256-saimbccJ5iJITs/Bw97bOkGrVcko1kAl61nlxNwBrms=";
    };
  };
})
