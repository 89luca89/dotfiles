# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    consoleLogLevel = 0;
    initrd.luks.devices.luksRoot.allowDiscards = true;
    initrd.verbose = false;
    plymouth.enable = true;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 100;
      };
    };
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "i915.fastboot=1"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "amdgpu.aspm=1"
      "amdgpu.cik_support=1"
      "amdgpu.dc=1"
      "amdgpu.dcfeaturemask='0xB'"
      "amdgpu.si_support=1"
      "dm_mod.use_blk_mq=1"
      "drm.debug=0"
      "drm.vblankoffdelay=1"
      "e1000e.SmartPowerDownEnable=1"
      "i915.disable_power_well=0"
      "i915.enable_dc=2"
      "i915.enable_fbc=1"
      "i915.enable_guc=3"
      "i915.enable_psr=1"
      "i915.enable_rc6=7"
      "i915.powersave=1"
      "iwlmvm.power_scheme=3"
      "iwlwifi.power_level=5"
      "iwlwifi.power_save=Y"
      "mmc_mod.use_blk_mq=1"
      "nvme_core.default_ps_max_latency_us=20000"
      "nvme_core.force_apst=1"
      "pcie_aspm=force"
      "pcie_aspm.policy=powersupersave"
      "scsi_mod.use_blk_mq=1"
      "thinkpad_acpi.fan_control=1"
      "usbcore.autosuspend=1"
    ];
    kernel.sysctl = {
      "kernel.nmi_watchdog"  = 0;
      "vm.laptop_mode"       = 5;
      "vm.swappiness"        = 5;
      "vm.oom_kill_allocating_task" = 1;
    };
  };


  # Enable networking
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "altgr-intl";
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  # Minimal gnome installation
  environment.gnome.excludePackages = [
    pkgs.simple-scan
    pkgs.gnome-connections
    pkgs.gnome-console
    pkgs.gnome-photos
    pkgs.gnome-text-editor
    pkgs.gnome-tour
    pkgs.gnome.cheese
    pkgs.gnome.eog
    pkgs.gnome.epiphany
    pkgs.gnome.evince
    pkgs.gnome.geary
    pkgs.gnome.gedit
    pkgs.gnome.gnome-calculator
    pkgs.gnome.gnome-calendar
    pkgs.gnome.gnome-characters
    pkgs.gnome.gnome-clocks
    pkgs.gnome.gnome-contacts
    pkgs.gnome.gnome-font-viewer
    pkgs.gnome.gnome-logs
    pkgs.gnome.gnome-maps
    pkgs.gnome.gnome-music
    pkgs.gnome.gnome-shell-extensions
    pkgs.gnome.gnome-software
    pkgs.gnome.gnome-terminal
    pkgs.gnome.gnome-weather
    pkgs.gnome.totem
    pkgs.gnome.yelp
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    flatpak
    fuse-overlayfs
    gnome.gnome-terminal
    gnome.seahorse
    virt-manager
  ];

  qt = {
    enable = true;
    platformTheme = "gnome";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.luca-linux = {
    isNormalUser = true;
    description = "luca-linux";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [
    ];
  };

  # Flatpak setup
  security.polkit.enable = true;
  services.flatpak.enable = true;
  services.dbus.packages = with pkgs; [ gnome2.GConf ];
  # This fixes flatpak icons/fonts access
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.fonts;
      pathsToLink = [ "/share/fonts" ];
    };
  in {
    # Create an FHS mount to support flatpak host icons/fonts
    "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
    "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  };

  # List services that you want to enable:
  programs.dconf.enable = true;
  services.fstrim.enable = true;
  services.openssh.enable = true;
  services.printing.enable = true;
  zramSwap.enable = true;

  # List services that you want to disable:
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.packagekit.enable = false;
  systemd.user.services.evolution-addressbook-factory.enable = false;
  systemd.user.services.evolution-calendar-factory.enable = false;
  systemd.user.services.evolution-source-registry.enable = false;
  systemd.user.services.evolution-user-prompter.enable = false;
  systemd.user.services.gamemoded.enable = false;
  systemd.user.services.gvfs-goa-volume-monitor.enable = false;
  systemd.user.services.tracker-extract-3.enable = false;
  systemd.user.services.tracker-miner-fs-3.enable = false;
  systemd.user.services.tracker-miner-fs-control-3.enable = false;
  systemd.user.services.tracker-miner-rss-3.enable = false;
  systemd.user.services.tracker-writeback-3.enable = false;
  systemd.user.services.tracker-xdg-portal-3.enable = false;

  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="acpi", ATTR{power/control}="auto"
    ACTION=="add|change", SUBSYSTEM=="ahci", ATTR{power/control}="auto"
    ACTION=="add|change", SUBSYSTEM=="block", ATTR{power/control}="auto"
    ACTION=="add|change", SUBSYSTEM=="i2c", ATTR{power/control}="auto"
    ACTION=="add|change", SUBSYSTEM=="pci", ATTR{power/control}="auto"
    ACTION=="add|change", SUBSYSTEM=="scsi", ATTR{power/control}="auto"
    ACTION=="add|change", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="min_power"
    ACTION=="add|change", SUBSYSTEM=="usb", ATTR{power/autosuspend}="1"
    ACTION=="add|change", SUBSYSTEM=="workqueue", ATTR{power/control}="auto"
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/iosched/low_latency}="1"
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/scheduler}="bfq"
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/read_ahead_kb}="4096"
    ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/read_ahead_kb}="16384"
  '';

  systemd.user.timers."flatpak-update" = {
    enable = true;
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1h";
      OnUnitActiveSec = "1d";
      Unit = "flatpak-update.service";
    };
  };

  systemd.user.services."flatpak-update" = {
    enable = true;
    script = ''
      /etc/profiles/per-user/$USER/bin/flatpak --user update --noninteractive --assumeyes
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

  systemd.user.timers."distrobox-update" = {
    enable = true;
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1h";
      OnUnitActiveSec = "1d";
      Unit = "distrobox-update.service";
    };
  };

  systemd.user.services."distrobox-update" = {
    enable = true;
    script = ''
      /home/$USER/.local/bin/distrobox upgrade --all
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = false;
      defaultNetwork.settings.dns_enabled = true;
    };
    docker = {
      enable = true;
    };
    libvirtd = {
      enable = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  documentation.nixos.enable = false;
  system.stateVersion = "23.05"; # Did you read the comment?
  system.autoUpgrade.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

}
