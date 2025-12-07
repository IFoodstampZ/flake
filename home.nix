{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];


  home.username = "alex";
  home.homeDirectory = "/home/alex";
  home.stateVersion = "25.05";

  

  home.packages = [
    pkgs.niri
    pkgs.xwayland-satellite
    inputs.nixcats.packages.x86_64-linux.nvim
  ];

  home.file."${config.xdg.configHome}" = {
    source = ./dotfiles;
    recursive = true;
  };
  


  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  programs.noctalia-shell = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovide.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "half-life";
      plugins = [ "git" "npm" ];
    };

    shellAliases = {
      btw = "echo i use nixos btw";
      fuck = "sudo nixos-rebuild switch --flake";
      nrs = "sudo nixos-rebuild switch";
      hm = "home-manager";
      hms = "home-manager switch";
    };
  
  };
  
  programs.foot = {
    enable = true;
    #theme = "gruvbox";
    settings = {
      main = {
        font="MapleMonoNF:size=12";
      };
    };

  };
  programs.home-manager.enable = true;


}
