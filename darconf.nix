{ config, pkgs, lib, inputs, wrappers, ... }:

let 
in
{
  imports =
    [
    ];

  nix.settings.experimental-features = "nix-command flakes";
  #system.configurationRevision = self.rev or self.dirtyRev or null;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

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
  ghostty
  #inputs.nixcats.packages.x86_64-linux.nvim
  #(./wrapper)
  ];

  fonts.packages = with pkgs; [
    maple-mono.NF-unhinted
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = 6; # Did you read the comment?

}

