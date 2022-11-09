#!/bin/bash

# -e: Abort script when error is occurred.
# -o: Abort script when error is occurred in pipeline
set -e -o pipefail


# cp /etc/nixos/configuration.nix ~/.config/nixpkgs/
# cp -r ~/.config/xmobar ~/.config/nixpkgs/cnf/
# cp -r ~/.config/xmonad ~/.config/nixpkgs/cnf/
# ln -sf ~/configuration.nix /etc/nixos/configuration.nix
ln -sf ~/.config/nixpkgs/cnf/xmobar/xmobarrc.hs ~/.config/xmobar/xmobarrc.hs
ln -sf ~/.config/nixpkgs/cnf/xmobad/xmobad.hs ~/.config/xmonad/xmonad.hs