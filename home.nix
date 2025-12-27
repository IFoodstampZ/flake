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
  
  #programs.noctalia-shell = {
  #  enable = true;
  #};

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
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
 

    '';
    */
  
  };
  
  programs.foot = {
    enable = true;
    #enableZshIntegration = true;
    #theme = "gruvbox";

  };

}
