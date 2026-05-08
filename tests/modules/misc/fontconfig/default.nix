{
  fontconfig-no-font-package = ./no-font-package.nix;
  fontconfig-single-font-package = ./single-font-package.nix;
  fontconfig-multiple-font-packages = ./multiple-font-packages.nix;
  fontconfig-native-font-cache-runs-fc-cache = ./native-font-cache-runs-fc-cache.nix;
  fontconfig-target-font-cache-uses-emulator = ./target-font-cache-uses-emulator.nix;

  fontconfig-default-rendering = ./default-rendering.nix;
  fontconfig-custom-rendering = ./custom-rendering.nix;
  fontconfig-extra-config-files = ./extra-config-files.nix;
}
