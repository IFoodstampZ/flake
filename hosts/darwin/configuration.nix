{ config, pkgs, lib, inputs, wrappers, ... }:

let 
in
{
  imports =
    [
      inputs.mnw.darwinModules.default
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
    EDITOR = "vim";
    XDG_CONFIG_HOME = "~/.config";
  };
  environment.shells = [ pkgs.nushell ];
  system.primaryUser = "alex";
  homebrew = {
    enable = true;
    taps = [];
    brews = [];
    casks = [
      "firefox"
      "ghostty"
      "steam" 
      "spotify"
      "qbittorrent"
      "discord"
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

  users.users.alex = {
    home = /Users/alex;
  };

  environment.systemPackages = with pkgs; [
  vim
  git
  wget
  yazi
  gh
  neofetch
  tmux
  stow
  btop
  alacritty
  fastfetch
  ripgrep
  emacs
  nushell
  yt-dlp
  yazi
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
  /*
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableFastSyntaxHighlighting = true;
    enableFzfCompletion = true;
    enableFzfHistory = true;
  };
  */
  
  environment.shellAliases = {
    fuck = "sudo darwin-rebuild switch --flake /Users/alex/flake/";
    edf = "cd /Users/alex/flake/hosts/darwin";
  };
  

  system.stateVersion = 6; # Did you read the comment?

}

