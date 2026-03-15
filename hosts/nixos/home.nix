{ config, pkgs, inputs, ... }:

{
  imports = [
    #inputs.noctalia.homeModules.default
  ];

  ### NOTES ###
  # dont forget to move nixos specific shit to nixos its commented


  home.username = "alex";
  #home.homeDirectory = "/home/alex";
  # ghetto compatibility
  home.homeDirectory = "/Users/alex/";
  home.stateVersion = "25.05";

  

  home.packages = [
    pkgs.niri
    pkgs.xwayland-satellite
  ];

  home.file."${config.xdg.configHome}" = {
    source = ./dotfiles;
    recursive = true;
  };
  


  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  #programs.noctalia-shell = {
  #  enable = true;
  #};

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovide.enable = true;

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
      #fuck = "sudo nixos-rebuild switch --flake";
      #move to respective conf
      you = ".";
    };
    /*
    enableGloba
    #dotDir = ".config/zsh";
    
    shellAliases = {
      btw = "echo i use nixos btw";
      fuck = "sudo nixos-rebuild switch --flake";
      you = ".";
    };
    
    initContent = ''
      PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
 

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
