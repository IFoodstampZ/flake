{ inputs, self, ... }:
{
  flake.nixosModules.phobosConfiguration =
    { config, pkgs, ... }:
    {

      imports = [
        self.nixosModules.phobosHardware
      ];

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      sops.secrets = {
        "sonarr/api_key" = { };
        "sonarr/password" = { };
        "radarr/api_key" = { };
        "radarr/password" = { };
        "lidarr/api_key" = { };
        "lidarr/password" = { };
        "prowlarr/api_key" = { };
        "prowlarr/password" = { };
        "jellyfin/api_key" = { };
        "jellyfin/admin_password" = { };
        "seerr/api_key" = { };
        "indexers/RuTracker/username" = { };
        "indexers/RuTracker/password" = { };
      };
      nixflix = {
        enable = true;
        mediaDir = "/data/media";
        stateDir = "/data/.state";
        theme = {
          enable = true;
          name = "overseerr";
        };
        postgres.enable = true;
        downloadarr = {
          enable = true;
          qbittorrent = {
            enable = true;
          };
        };
        sonarr = {
          enable = true;
          config = {
            apiKey._secret = config.sops.secrets."sonarr/api_key".path;
            hostConfig.password._secret = config.sops.secrets."sonarr/password".path;
          };
        };
        radarr = {
          enable = true;
          config = {
            apiKey._secret = config.sops.secrets."radarr/api_key".path;
            hostConfig.password._secret = config.sops.secrets."radarr/password".path;
          };
        };
        recyclarr = {
          enable = false;
          cleanupUnmanagedProfiles.enable = true;
        };

        lidarr = {
          enable = true;
          config = {
            apiKey._secret = config.sops.secrets."lidarr/api_key".path;
            hostConfig.password._secret = config.sops.secrets."lidarr/password".path;
          };
        };
        prowlarr = {
          enable = true;
          config = {
            apiKey._secret = config.sops.secrets."prowlarr/api_key".path;
            hostConfig.password._secret = config.sops.secrets."prowlarr/password".path;
            indexers = [
              {
                name = "RuTracker.org";
                username._secret = config.sops.secrets."indexers/RuTracker/username".path;
                password._secret = config.sops.secrets."indexers/RuTracker/password".path;
              }
            ];
          };
        };
        jellyfin = {
          enable = true;
          apiKey._secret = config.sops.secrets."jellyfin/api_key".path;
          users = {
            admin = {
              mutable = false;
              policy.isAdministrator = true;
              password._secret = config.sops.secrets."jellyfin/admin_password".path;
            };
          };
        };
        seerr = {
          enable = false;
          apiKey._secret = config.sops.secrets."seerr/api_key".path;
        };
        vpn = {
          #          enable = true;
          #         wgConfFile = config.sops.secrets."wireguard/conf".path;
          #         accessibleFrom = [ "192.168.1.0/24" ];
        };

      };

      ### services
      services = {
        glance.enable = true;
        caddy = {
          enable = false;
          package = pkgs.caddy.withPlugins {
            plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
            hash = "sha256-Olz4W84Kiyldy+JtbIicVCL7dAYl4zq+2rxEOUTObxA=";
          };
          environmentFile = "/home/alex/secrets/caddy.env";
          virtualHosts = {
            #"vanillakitty.com".extraConfig = ''
            #  reverse_proxy 192.168.1.85:8096
            #  tls {
            #    dns cloudflare {$CLOUDFLARE_API_KEY}
            #  }
            #'';
            "media.vanillakitty.com".extraConfig = ''
              reverse_proxy 192.168.1.85:8096
              tls {
                dns cloudflare {$CLOUDFLARE_API_KEY}
              }
            '';
            "localhost".extraConfig = ''
              tls internal
              reverse_proxy :8082
            '';

          };
        };
        homepage-dashboard = {
          enable = true;
          services = [
            {
              "media" = [
                {
                  "jellyfin" = {
                    description = "cool";
                    href = "http://localhost:8096";
                  };
                }
                {
                  "seerr" = {
                    description = "cool too";
                    href = "http://localhost:5055";
                  };
                }
              ];
            }
          ];
          allowedHosts = "localhost";
        };
      };

      sops.defaultSopsFile = ../../../secrets/secrets.yaml;
      sops.defaultSopsFormat = "yaml";

      sops.age.keyFile = "/home/alex/.config/sops/age/keys.txt";

      # Bootloader.
      #boot.loader.systemd-boot.enable = true;
      boot.loader.limine = {
        enable = true;
        style.wallpapers = [ ../../../wallpapers/wp15785927-charlie-kirk-wallpapers.jpg ];
        style.wallpaperStyle = "stretched";
        style.interface.helpHidden = false;
      };
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "phobos"; # Define your hostname.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Enable networking
      networking.networkmanager.enable = true;

      # Set your time zone.
      time.timeZone = "America/New_York";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      # Enable the X11 windowing system.
      services.xserver.enable = true;

      # Enable the GNOME Desktop Environment.
      services.displayManager.gdm.enable = true;
      services.desktopManager.plasma6.enable = true;

      programs.niri.enable = true;

      programs.steam = {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
      };

      # Enable touchpad support (enabled default in most desktopManager).
      # services.xserver.libinput.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
      users.users.alex = {
        isNormalUser = true;
        description = "alex";
        extraGroups = [
          "networkmanager"
          "wheel"
          "libvirtd"
          "libvirt"
          "input"
          "kvm"
        ];
        packages = with pkgs; [
          #  thunderbird
        ];
      };

      # Install firefox.
      programs.firefox.enable = true;

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        vim
        git
        wget
        ghostty
        #yazi
        nss
        nss.tools
        sops
        gh
        tmux
        stow
        btop
        fastfetch
        tldr
        virt-manager
        qemu
        gnumake
        qbittorrent
        protonup-qt
        self.packages.${pkgs.system}.neovim
        foot
        #inputs.nixcats.packages.x86_64-linux.nvim
        #(./wrapper)
      ];

      fonts.packages = with pkgs; [
        maple-mono.NF-unhinted
      ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      services.openssh.enable = true;

      # Open ports in the firewall.
      networking.firewall.allowedTCPPorts = [
        80
        443
        8096
      ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.05"; # Did you read the comment?

    };
}
