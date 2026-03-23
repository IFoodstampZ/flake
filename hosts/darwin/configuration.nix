{
  config,
  pkgs,
  lib,
  inputs,
  wrappers,
  ...
}:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};

in
{
  imports = [
    inputs.spicetify-nix.darwinModules.spicetify
  ];

  nix.settings.experimental-features = "nix-command flakes";
  #system.configurationRevision = self.rev or self.dirtyRev or null;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  security.pam = {
    services.sudo_local = {
      enable = true;
      #reAttatch = true;
      touchIdAuth = true;
    };
  };
  environment.variables = {
    EDITOR = "nvim";
    XDG_CONFIG_HOME = "~/.config";
  };
  environment.shells = [ pkgs.nushell ];
  system.primaryUser = "alex";
  homebrew = {
    enable = true;
    taps = [ ];
    brews = [ ];
    casks = [
      "ghostty"
      "firefox"
      "steam"
      "qbittorrent"
      "discord"
      "google-chrome"
      "telegram"
      "roblox"
      "librewolf"
    ];
  };
  /*
    programs.mnw = {
      enable = true;
      initLua = ''
        require("myconfig")
      '';
      plugins = {
        start = [
          pkgs.vimPlugins.oil-nvim
        ];
      };
    };
  */

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      shuffle
    ];
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };

  users.users.alex = {
    home = /Users/alex;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    yazi
    gh
    tmux
    tldr
    stow
    btop
    alacritty
    fastfetch
    ripgrep
    emacs
    nushell
    yt-dlp
    pipx
    python3
    yazi
    unrar
    cmake
    fzf
    zoxide
    typst
    ffmpeg
    spotdl
    inputs.self.packages.aarch64-darwin.less
    inputs.self.packages.aarch64-darwin.neovim
    #inputs.nixcats.packages.x86_64-linux.nvim
    #(./wrapper)
  ];

  fonts.packages = with pkgs; [
    maple-mono.NF-unhinted
  ];

  system.defaults = {
    dock.mru-spaces = false;
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.LoginwindowText = "dih";
  };

  programs.direnv.enable = true;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableFastSyntaxHighlighting = true;
    enableFzfCompletion = true;
    enableFzfHistory = true;
    promptInit = ''PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "'';
    interactiveShellInit = ''
      autoload -U colors && colors
      eval "$(zoxide init zsh)"
      eval "$(direnv hook zsh)"
    '';
  };

  environment.shellAliases = {
    fuck = "sudo darwin-rebuild switch --flake /Users/alex/flake/";
    edf = "cd /Users/alex/flake/hosts/darwin";
    zd = "z";
    ox = "z";
    ls = "ls --color=auto";
    cd = "z";
    vd = "nvim .";
  };

  system.stateVersion = 6; # Did you read the comment?

}
