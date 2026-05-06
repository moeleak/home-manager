{ lib, ... }:

{
  config = {
    programs.fish.enable = true;

    xdg.dataFile."fish/home-manager/generated_completions".source = lib.mkForce (
      builtins.toFile "empty" ""
    );

    nmt = {
      description = "fish should include completions and functions from the Home Manager profile";
      script = ''
        assertFileExists home-files/.config/fish/config.fish

        assertFileContains \
          home-files/.config/fish/config.fish \
          "set -l profile /home/hm-user/.nix-profile"

        assertFileContains \
          home-files/.config/fish/config.fish \
          '$profile/share/fish/vendor_completions.d'

        assertFileContains \
          home-files/.config/fish/config.fish \
          '$profile/share/fish/vendor_functions.d'

        assertFileContains \
          home-files/.config/fish/config.fish \
          'set fish_complete_path $fish_complete_path[1] $completion_paths $fish_complete_path[2..-1]'

        assertFileContains \
          home-files/.config/fish/config.fish \
          'set fish_function_path $fish_function_path[1] $function_paths $fish_function_path[2..-1]'

        profileCompletionLine=$(
          grep -nF '$profile/share/fish/vendor_completions.d' \
            "$TESTED/home-files/.config/fish/config.fish" \
            | cut -d: -f1
        )
        generatedCompletionLine=$(
          grep -nF 'generated_completions' \
            "$TESTED/home-files/.config/fish/config.fish" \
            | head -n 1 \
            | cut -d: -f1
        )

        if [[ $profileCompletionLine -ge $generatedCompletionLine ]]; then
          fail "Expected profile completions to be added before generated completions."
        fi
      '';
    };
  };
}
