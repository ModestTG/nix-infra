{ self, ... }:
{
  flake.modules.nixos.swayWm =
    { pkgs, ... }:
    {
      home-manager.users.eweishaar.imports = with self.modules.homeManager; [
        dunst
        nerdFonts
        swayidle
        swaylock
        swayWm
        waybar
        wlogout
        wofi
      ];
      programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        package = pkgs.swayfx;
        extraPackages = with pkgs; [
          autotiling
          playerctl
          wl-clipboard
          xdg-utils
        ];
      };
      security.pam.services.swaylock = { };
    };
  flake.modules.homeManager.swayidle =
    { pkgs, ... }:
    {
      services.swayidle =
        let
          lockCmd = "${pkgs.swaylock-effects}/bin/swaylock -fF";
        in
        {
          enable = true;
          timeouts = [
            {
              timeout = 300;
              command = lockCmd;
            }
            {
              timeout = 305;
              command = "${pkgs.swayfx}/bin/swaymsg 'output * dpms off'";
              resumeCommand = "${pkgs.swayfx}/bin/swaymsg 'output * dpms on'";
            }
          ];
          events = {
            "before-sleep" = lockCmd;
          };
        };
    };
  flake.modules.homeManager.swaylock =
    { pkgs, ... }:
    {
      programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
        settings = {
          show-failed-attempts = true;
          font-size = 24;
          screenshots = true;
          indicator-radius = 120; # Size of the indicator
          indicator-thickness = 8; # ; Thickness of the ring
          clock = true;
          indicator = true; # Show; indicator
          grace = 2; # ; Grace period for unlocking
          effect-blur = "7x5"; # Apply a blur effect
        };
      };
    };
  flake.modules.homeManager.swayWm =
    { pkgs, ... }:
    {
      wayland.systemd.target = "sway-session.target";
      wayland.windowManager.sway =
        let
          modifier = "Mod4";
          border = 2;
          titlebar = false;
          fonts = {
            names = [ "FiraCodeNerdFont" ];
            style = "Medium";
            size = 10.0;
          };
        in
        {
          enable = true;
          package = pkgs.swayfx;
          wrapperFeatures.gtk = true;
          checkConfig = false;
          config = {
            inherit modifier fonts;
            defaultWorkspace = "workspace number 1";
            workspaceLayout = "default";
            workspaceAutoBackAndForth = false;
            gaps = {
              inner = 6;
              top = -6;
            };
            window = {
              inherit border titlebar;
              hideEdgeBorders = "none";
            };
            floating = {
              inherit modifier border titlebar;
              criteria = [
                {
                  app_id = "org.pulseaudio.pavucontrol";
                }
              ];
            };
            focus = {
              wrapping = "no";
              followMouse = "yes";
              newWindow = "smart";
              mouseWarping = "output";
            };
            keybindings = {
              "${modifier}+0" = "nop";
              "${modifier}+1" = "workspace number 1";
              "${modifier}+2" = "workspace number 2";
              "${modifier}+3" = "workspace number 3";
              "${modifier}+4" = "workspace number 4";
              "${modifier}+5" = "workspace number 5";
              "${modifier}+6" = "nop";
              "${modifier}+7" = "nop";
              "${modifier}+8" = "nop";
              "${modifier}+9" = "nop";
              # "${modifier}+Down" = "focus down";
              # "${modifier}+Left" = "focus left";
              "${modifier}+Return" = "exec ${pkgs.kitty}/bin/kitty";
              # "${modifier}+Right" = "focus right";
              # "${modifier}+Shift+0" = "move container to workspace number 10";
              "${modifier}+Shift+1" = "move container to workspace number 1";
              "${modifier}+Shift+2" = "move container to workspace number 2";
              "${modifier}+Shift+3" = "move container to workspace number 3";
              "${modifier}+Shift+4" = "move container to workspace number 4";
              "${modifier}+Shift+5" = "move container to workspace number 5";
              # "${modifier}+Shift+6" = "move container to workspace number 6";
              # "${modifier}+Shift+7" = "move container to workspace number 7";
              # "${modifier}+Shift+8" = "move container to workspace number 8";
              # "${modifier}+Shift+9" = "move container to workspace number 9";
              "${modifier}+Shift+Down" = "move down";
              "${modifier}+Shift+Left" = "move left";
              "${modifier}+Shift+Right" = "move right";
              "${modifier}+Shift+Up" = "move up";
              "${modifier}+Shift+q" = "reload";
              # "${modifier}+Shift+e" =
              #   "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
              # "${modifier}+Shift+h" = "move left";
              # "${modifier}+Shift+j" = "move down";
              # "${modifier}+Shift+k" = "move up";
              # "${modifier}+Shift+l" = "move right";
              # "${modifier}+Shift+minus" = "move scratchpad";
              "${modifier}+q" = "kill";
              "${modifier}+Shift+space" = "floating toggle";
              # "${modifier}+Up" = "focus up";
              # "${modifier}+a" = "focus parent";
              "${modifier}+b" = "exec ${
                self.packages.${pkgs.stdenv.hostPlatform.system}.helium-browser
              }/bin/helium-browser";
              "${modifier}+d" = "nop";
              "${modifier}+r" = "exec ${pkgs.wofi}/bin/wofi";
              "${modifier}+e" = "exec ${pkgs.thunar}/bin/thunar";
              "${modifier}+f" = "fullscreen toggle";
              # "${modifier}+h" = "focus left";
              # "${modifier}+j" = "focus down";
              # "${modifier}+k" = "focus up";
              "${modifier}+l" = "exec ${pkgs.swaylock-effects}/bin/swaylock";
              # "${modifier}+minus" = "scratchpad show";
              # "${modifier}+Shift+r" = "mode resize";
              # "${modifier}+s" = "layout stacking";
              # "${modifier}+space" = "focus mode_toggle";
              # "${modifier}+v" = "splitv";
              # "${modifier}+w" = "layout tabbed";
              "${modifier}+Shift+s" = "exec ${pkgs.flameshot}/bin/flameshot gui";
              "${modifier}+p" = "exec playerctl -p Feishin play-pause";
              "${modifier}+Ctrl+Right" = "exec playerctl -p Feishin next";
              "${modifier}+Ctrl+Left" = "exec playerctl -p Feishin previous";
            };
            bars = [
              {
                inherit fonts;
                command = "${pkgs.waybar}/bin/waybar";
              }
            ];
            assigns = {
              "3" = [ { app_id = "^feishin$"; } ];
              "4" = [
                { class = "^discord$"; }
              ];
            };
            startup = [
              {
                command = "${pkgs.autotiling}/bin/autotiling";
                always = true;
              }
              {
                command = "${pkgs.feishin}/bin/feishin";
              }
              {
                command = "${pkgs.discord}/bin/discord";
              }
            ];
          };
          extraConfig = ''
            for_window [title="alacritty-BC"] floating enable, resize set 600 800
            input type:keyboard repeat_delay 300
            input type:keyboard repeat_rate 50
          '';
        };
      services.wpaperd = {
        enable = true;
        settings = {
          DP-1 = {
            path = builtins.toPath "${self.outPath}/wallpapers/2560x1440";
            duration = "10m";
            sorting = "random";
            mode = "fit";
          };
        };
      };
    };
}
