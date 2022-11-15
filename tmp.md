When I try to open a gui app, I always face this error message(NixOS on (VirutalBox on OSX)).


```sh
$ libreoffice
Gtk-Message: 17:41:41.774: Failed to load module "colorreload-gtk-module"
```

or

```sh
$ firefox          
Gtk-Message: 17:42:07.764: Failed to load module "colorreload-gtk-module"
```


# Version Info
## nixos

WM: xmonad

<details>
    <summary>configuration.nix</summary>

```nix
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
#   home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # <home-manager/nixos>
      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "ja_JP.utf8";

  # Set Input Method!
  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = false;
  services.xserver.desktopManager.plasma5.enable = false;

  # https://github.com/NixOS/nixpkgs/issues/80936#issuecomment-1003784682
  #XXX {{{
  # virtualisation.virtualbox.host.enalbe = true;
  # virtualisation.virtualbox.host.enalbeHardening = false;
  # users.extraUsers.hix.extraGroups = ["vboxusers"];
  services.xserver.videoDrivers = ["virtualbox"];
  #}}}

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";

    # The xmonad setting
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.dbus
          haskellPackages.List
          haskellPackages.monad-logger
          haskellPackages.xmonad
          haskellPackages.xmonad-contrib
        ];
      };
    };
  };
  services.compton.enable = true;
  services.compton.shadow = true;
  services.compton.inactiveOpacity = 0.8;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hix = {
    isNormalUser = true;
    description = "hix";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "hix";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowBroken = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    gcc
    deno
    nodejs
    git
    gh
    # helix

    # Essential commands
    zip
    unzip
    file # Show the type of files

    starship # shell prompt

    # Browser
    qutebrowser

    #FIXME I dont know whether if this gtk's work.
    gtk4

    # For The xmonad
    xterm
    gmrun
    dmenu
    alacritty
    kitty

    # CTF
    radare2 # Reverse engineering framework

    # File manager
    xfce.thunar

    # PDF reader
    okular

    # office app
    libreoffice

    # A minimalistic Text Based Status Bar
    haskellPackages.xmobar

    # Latex
    texlive.combined.scheme-full

    # Python
    (let
      my-python-packages = python-packages: with python-packages; [
        pandas
        requests
      #other python packages you want
      ];
      python-with-my-packages = python3.withPackages my-python-packages;
    in
    python-with-my-packages)

    # Rust
    rustup
    cargo

    # Haskell
    # haskellPackages.haskell-language-server
    haskellPackages.hoogle
    haskellPackages.gtk2hs-buildtools
    # haskellPackages.ghcup
    # cabal-install
    # stack
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Fonts
  fonts.fonts = with pkgs; [
    # 日本語適当 {{{
    carlito
    dejavu_fonts
    ipafont
    ipaexfont
    kochi-substitute
    source-code-pro
    ttf_bitstream_vera
    # }}}
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "DejaVu Sans Mono"
      "IPAGothic"
    ];
    sansSerif = [
      "DejaVu Sans"
      "IPAPGothic"
    ];
    serif = [
      "DejaVu Serif"
      "IPAPMincho"
    ];
  };

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
  system.stateVersion = "22.05"; # Did you read the comment?

  home-manager.users.hix = { config, pkgs, ... }: {
    programs.home-manager.enable = true;
    home.username = "hix";
    home.homeDirectory = "/home/hix";

    home.packages = [
      pkgs.zsh
    ];

    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
        config = "sudo -e /etc/nixos/configuration.nix";
        nixpkgs = "cd ~/.config/nixpkgs";
        open = "thunar";
        alac = "LIBGL_ALWAYS_SOFTWARE=1 alacritty"; #XXX alacritty
        kitt = "LIBGL_ALWAYS_SOFTWARE=true GALLIUM_DRIVER=llvmpipe kitty"; #XXX kitty
      };
      initExtra = ''
        bindkey -e
        export XMODIFIERS=@im=fcitx
        export GTK_IM_MODULE=fcitx
        export QT_IM_MODULE=fcitx

        eval "$(starship init zsh)" # Setup my shell to use Starship
      '';
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
          # { name = "romkatv/powerlevel10k"; }
        ];
      };
    };
  };
}
```

</details>
## VirtualBox

```
$ vertualbox -h
Oracle VM VirtualBox VM Selector v6.1.38
(C) 2005-2022 Oracle Corporation
All rights reserved.
```

## OSX(HOST)

```sh
$ sw_vers
ProductName:	macOS
ProductVersion:	12.6
BuildVersion:	21G11
```

### gpu info
```sh
$ sudo powermetrics --samplers gpu_power -i500 -n1
Machine model: MacBookPro15,2
SMC version: Unknown
EFI version: 1731.2.0
OS version: 21G115
Boot arguments: chunklist-security-epoch=0 -chunklist-no-rev2-dev chunklist-security-epoch=0 -chunklist-no-rev2-dev
Boot time: Thu Nov 10 23:09:43 2022



*** Sampled system activity (Tue Nov 15 17:54:02 2022 +0900) (500.57ms elapsed) ***


**** GPU usage ****

GPU 0 name IntelIG
```


