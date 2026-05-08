{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  test.unstubs = [
    (
      _self: super:
      let
        targetFontconfig = super.runCommandLocal "target-fontconfig" { } ''
          mkdir -p $out/bin
          cat > $out/bin/fc-cache <<EOF
          #!${super.runtimeShell}
          echo "target fc-cache was executed directly" >&2
          exit 123
          EOF
          chmod +x $out/bin/fc-cache
        '';

        emulator = super.runCommandLocal "target-fontconfig-emulator" { } ''
          mkdir -p $out/bin
          cat > $out/bin/emulator <<'EOF'
          #!${super.runtimeShell}
          case "$1" in
            */bin/fc-cache) ;;
            *)
              echo "unexpected emulated executable: $1" >&2
              exit 124
              ;;
          esac
          mkdir -p "$out/lib/fontconfig/cache"
          echo "emulated fc-cache" > "$out/lib/fontconfig/cache/emulated.cache"
          EOF
          chmod +x $out/bin/emulator
        '';
      in
      {
        fontconfig = targetFontconfig;
        stdenv = super.stdenv // {
          buildPlatform = super.stdenv.buildPlatform // {
            canExecute = _hostPlatform: false;
          };
          hostPlatform = super.stdenv.hostPlatform // {
            emulator = _buildPackages: "${emulator}/bin/emulator";
            emulatorAvailable = _buildPackages: true;
          };
        };
      }
    )
  ];

  home.packages = [
    (pkgs.runCommandLocal "font-package" { } ''
      mkdir -p $out/share/fonts
      touch $out/share/fonts/test-font.ttf
    '')
  ];

  nmt.script = ''
    assertFileExists home-path/lib/fontconfig/cache/emulated.cache
  '';
}
