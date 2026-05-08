{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  test.unstubs = [
    (_self: super: {
      fontconfig = super.runCommandLocal "native-fontconfig" { } ''
        mkdir -p $out/bin
        cat > $out/bin/fc-cache <<'EOF'
        #!${super.runtimeShell}
        mkdir -p "$out/lib/fontconfig/cache"
        echo "native fc-cache" > "$out/lib/fontconfig/cache/native.cache"
        EOF
        chmod +x $out/bin/fc-cache
      '';
    })
  ];

  home.packages = [
    (pkgs.runCommandLocal "font-package" { } ''
      mkdir -p $out/share/fonts
      touch $out/share/fonts/test-font.ttf
    '')
  ];

  nmt.script = ''
    assertFileExists home-path/lib/fontconfig/cache/native.cache
  '';
}
