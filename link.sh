#!/bin/bash

# -e: Abort script when error is occurred.
# -o: Abort script when error is occurred in pipeline
set -e -o pipefail


# cp /etc/nixos/configuration.nix ~/.config/nixpkgs/
# cp -r ~/.config/xmobar ~/.config/nixpkgs/cnf/
# cp -r ~/.config/xmonad ~/.config/nixpkgs/cnf/
# ln -sf ~/configuration.nix /etc/nixos/configuration.nix
ln -sf ~/.config/nixpkgs/cnf/xmobar/xmobarrc.hs ~/.config/xmobar/xmobarrc.hs
ln -sf ~/.config/nixpkgs/cnf/xmonad/xmonad.hs ~/.config/xmonad/xmonad.hs
ln -sf ~/.config/nixpkgs/cnf/kitty/kitty.conf ~/.config/kitty/kitty.conf
ln -sf ~/.config/nixpkgs/cnf/zsh/.zshrc.nixos ~/.config/zsh/.zshrc.nixos
