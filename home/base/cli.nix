{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      file
      git-crypt
      htop
      httpie
      jq
    ];
   shell.enableZshIntegration = true;
  };

  programs = {
    atuin.enable = true;
    fastfetch.enable = true;
    bat.enable = true;
    broot.enable = true;
    eza.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      dotDir = lib.mkIf pkgs.stdenv.hostPlatform.isLinux "${config.xdg.configHome}/zsh"; # 26.05
      defaultKeymap = "emacs";
      initContent = ''
        source ${./zsh/completion.zsh}
        source ${./zsh/key-bindings.zsh}
      '';
    };

    starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          "[](red)$os"
          "$username"
          "$hostname"
          "[](bg:peach fg:red)"
          "$directory"
          "[](bg:yellow fg:peach)"
          "$git_branch"
          "$git_status"
          "[](fg:yellow bg:green)"
          "$c"
          "$rust"
          "$golang"
          "$nodejs"
          "$php"
          "$java"
          "$kotlin"
          "$haskell"
          "$python"
          "[](fg:green bg:sapphire)"
          "$conda"
          "[](fg:sapphire bg:lavender)"
          "$time"
          "[ ](fg:lavender)"
          "$cmd_duration"
          "$line_break"
          "$character"
        ];
        username = {
          show_always = false;
          format = "[$user]($style)";
        };
        hostname = {
          format = "[$ssh_symbol$hostname]($style)";
          style = "bg:red fg:crust";
          ssh_symbol = "🌐";
        };
      };
      presets = ["catppuccin-powerline"];
    };

    git = {
      enable = true;
      settings = {
        user = {
          name  = "Safiro Szperling";
          email = "zebaszp@gmail.com";
        };
        init.defaultBranch = "main";
        alias = {
          co = "checkout";
          st = "status";
        };
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
      withRuby = false; # 26.05
      withPython3 = false; # 26.05
    };
  };

  # messes up with the preset
  catppuccin.starship.enable = false;
}