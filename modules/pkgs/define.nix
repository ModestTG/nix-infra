{
  perSystem =
    { pkgs, ... }:
    {
      packages.define = pkgs.writeShellApplication {
        name = "define";
        runtimeInputs = with pkgs; [
          curl
          jq
          libnotify
          wl-clipboard
        ];
        text = ''
          # attribution to BreadOnPenguins
          # https://raw.githubusercontent.com/BreadOnPenguins/scripts/refs/heads/master/shortcuts-menus/define

          word="''${1:-$(xclip -o -selection primary 2>/dev/null || wl-paste 2>/dev/null)}"

          # Check for empty word or special characters
          [[ -z "$word" || "$word" =~ [\/] ]] && notify-send -h string:bgcolor:#bf616a -t 3000 "Invalid input." && exit 0

          if ! query=$(curl -s --connect-timeout 5 --max-time 10 "https://api.dictionaryapi.dev/api/v2/entries/en_US/$word"); then
            notify-send -h string:bgcolor:#bf616a -t 3000 "Connection error."
            exit 1
          fi

          # Check for invalid word response
          [[ "$query" == *"No Definitions Found"* ]] && notify-send -h string:bgcolor:#bf616a -t 3000 "Invalid word." && exit 0

          # Show only first 3 definitions
          def=$(echo "$query" | jq -r '[.[].meanings[] | {pos: .partOfSpeech, def: .definitions[].definition}] | .[:3].[] | "\n\(.pos). \(.def)"')

          # Requires a notification daemon to be installed
          notify-send -t 10000 "$word -" "$def"
        '';
      };
    };
}
