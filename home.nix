{ config, pkgs, secrets, ... }:

{
  home.username = "tanner";
  home.homeDirectory = "/home/tanner";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  #xresources.properties = {
  #  "Xcursor.size" = 16;
  #  "Xft.dpi" = 172;
  #};

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # shell
    cool-retro-term
    zellij
    zsh

    # web
    firefox

    # communications
    discord
    element-desktop
    signal-desktop
    slack
    tootle
    tuba

    # gaming
    steam

    #neofetch
    #nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    #p7zip

    # git
    gh
    git

    # utils
    #ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    nfs-utils
    #yq-go # yaml processor https://github.com/mikefarah/yq
    #eza # A modern replacement for ‘ls’
    #fzf # A command-line fuzzy finder

    # networking tools
    #mtr # A network diagnostic tool
    #iperf3
    dnsutils  # `dig` + `nslookup`
    #ldns # replacement of `dig`, it provide the command `drill`
    #aria2 # A lightweight multi-protocol & multi-source command-line download utility
    #socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    #cowsay
    #file
    gnupg
    gnused
    gnutar
    gawk
    pinentry
    thefuck
    tree
    which
    zstd

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal
    hugo # static site generator
    kate # ide

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    #enableSSHSupport = true;
    pinentryFlavor = "curses";
  };

  programs.git = {
    enable = true;
    userName = "Tanner Lake";
    userEmail = "tanner.lake@protonmail.com";
    aliases = {
      hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";

      # remove branches that no longer exist remotely
      sync = "!git fetch --all --prune && for b in $(git branch -vv | awk '/: gone]/{print $1}') ; do echo \"Deleting branch $b\" ; git branch -d $b ; done";

      # as above, but also remove branches that are NOT FULLY MERGED
      fsync = "!git fetch --all --prune && for b in $(git branch -vv | awk '/: gone]/{print $1}') ; do echo \"Deleting branch $b\" ; git branch -D $b ; done";
    };

    extraConfig = {
      init.defaultBranch = "main";
      core = {
        pager = "cat";
      };
      rerere.enabled = true;
      push = {
        default = "simple";
	autoSetupRemote = true;
      };
      user.signingkey = "${secrets.git.signing_key}";
      commit.gpgsign = true;
      gpg.program = "gpg";
    };
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "juanghurtado";
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

  # starship - an customizable prompt for any shell
  #programs.starship = {
  #  enable = true;
  #  # custom settings
  #  settings = {
  #    add_newline = false;
  #    aws.disabled = true;
  #    gcloud.disabled = true;
  #    line_break.disabled = true;
  #  };
  #};

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  #programs.alacritty = {
  #  enable = true;
  #  # custom settings
  #  settings = {
  #    env.TERM = "xterm-256color";
  #    font = {
  #      size = 12;
  #      draw_bold_text_with_bright_colors = true;
  #    };
  #    scrolling.multiplier = 5;
  #    selection.save_to_clipboard = true;
  #  };
  #};

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      k = "kubectl";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
