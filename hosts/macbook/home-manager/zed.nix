{ ... }:
{
  home.shellAliases = {
    z = "zeditor";
  };

  programs.zed-editor = {
    enable = true;
    mutableUserSettings = false;
    extensions = [
      "github-actions"
      "hexpeek"
      "html"
      "make"
      "nix"
      "terraform"
      "toml"
    ];

    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          alt-q = "editor::Rewrap";
          alt-shift-l = "editor::SplitSelectionIntoLines";
        };
      }
    ];

    userSettings = {
      auto_update = false;
      base_keymap = "VSCode";
      cli_default_open_behavior = "new_window";
      disable_ai = true;
      buffer_font_features = {
        calt = false;
        liga = false;
      };
      load_direnv = "direct";
      preferred_line_length = 80;
      wrap_guides = [
        80
        100
        120
      ];
      telemetry.metrics = false;
      toolbar.agent_review = false;
      git.inline_blame.enabled = false;
      gutter.breakpoints = false;
      inline_code_actions = false;
      format_on_save = "off";

      # Temporary workaround for Zed/vtsls TypeScript indentation bugs while typing.
      # Re-check before removing:
      # - https://github.com/zed-industries/zed/issues/32425
      # - https://github.com/zed-industries/zed/issues/47912
      languages = {
        TypeScript.use_on_type_format = false;
        TSX.use_on_type_format = false;
      };

      project_panel = {
        dock = "left";
        starts_open = true;
      };

      title_bar = {
        show_onboarding_banner = false;
        show_sign_in = false;
        show_user_menu = false;
        show_user_picture = false;
      };

      theme_overrides."Ayu Dark".syntax = {
        comment.color = "#ff5c66";
        "comment.doc".color = "#ff5c66";
      };

      theme = "Ayu Dark";
    };
  };
}
