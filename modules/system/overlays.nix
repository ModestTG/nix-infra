{
  flake.overlays = {
    tokyonight-gtk-theme = final: prev: {
      tokyonight-gtk-theme = prev.tokyonight-gtk-theme.override {
        iconVariants = [
          "Dark"
          "Light"
        ];
      };
    };
  };
}
