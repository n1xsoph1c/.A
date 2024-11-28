#!/bin/bash

# fresh-install after pacstrap
# Assuming it already has:
# vim, git, devetools, base devel

#!/bin/bash

# Define color codes
green='\e[32m'
blue='\e[34m'
clear='\e[0m'

# Function to install paru
install_paru() {
  cd || exit
  mkdir -p Sources
  cd Sources || exit
  git clone https://aur.archlinux.org/paru.git
  cd paru || exit
  makepkg -si
}

# Function to print messages in green
col_green() {
  echo -ne "$green$*$clear"
}

# Function to print messages in blue
col_blue() {
  echo -ne "$blue$*$clear"
}

# Function to install packages
install_packages() {
  sudo pacman -S --needed fzf rustup nodejs npm gdm sddm python-pywal rofi-wayland calc lxappearance
  paru -S networkmanager-dmenu-bluetoothfix-git
}

# Function to install Neovim and LazyVim
install_vim() {
  sudo pacman -S --needed neovide neovim
  # Backup existing Neovim configuration
  mv ~/.config/nvim ~/.config/nvim.bak
  # Clone LazyVim starter template
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  # Remove .git folder to allow personal version control
  rm -rf ~/.config/nvim/.git
  # Start Neovim to initialize LazyVim
  nvim
}

# Function to install fonts
install_fonts() {
  sudo pacman -S --needed ttf-firacode-nerd ttf-font-awesome ttf-material-design-iconic-font \
    ttf-fantasque-sans-mono noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-dejavu \
    ttf-liberation ttf-opensans
  paru -S ttf-ms-win10-auto ttf-ms-win11-auto otf-apple-fonts

  echo "[!] --> Enabling ClearType"
  paru -S freetype2
  echo 'export FREETYPE_PROPERTIES="truetype:interpreter-version=40"' | sudo tee /etc/profile.d/freetype2.sh

  mkdir -p ~/.config/fontconfig/conf.d/
  cat <<EOF >~/.config/fontconfig/conf.d/20-no-embedded.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <match target="font">
    <edit name="embeddedbitmap" mode="assign">
      <bool>false</bool>
    </edit>
  </match>
</fontconfig>
EOF

  fc-cache -vc
}

# Function to install touchpad gestures
install_touch_pad() {
  sudo pacman -S --needed xdotool wmctrl
  paru -S libinput-gestures

  sudo gpasswd -aG input "$USER"
}

# Function to create symbolic links
create_symlinks() {
  echo -ne "$(col_blue '[!]') -> Creating symbolic links"

  mkdir -p ~/.config
  ln -sf ~/.A/fontconfig ~/.config/fontconfig
  ln -sf ~/.A/picom/ ~/.config/picom
  ln -sf ~/.A/kitty/ ~/.config/kitty
  ln -sf ~/.A/i3/ ~/.config/i3
  ln -sf ~/.A/rofi/ ~/.config/rofi
  ln -sf ~/.A/libinput-gestures.conf ~/.config/libinput-gestures.conf
  ln -sf ~/.A/polybar/ ~/.config/polybar
  ln -sf ~/.A/.Xresources ~/.Xresources
  ln -sf ~/.A/.oh-my-zsh/ ~/.oh-my-zsh
  ln -sf ~/.A/.zshrc ~/.zshrc
}

# Main function to orchestrate the installation
main() {
  echo -ne "$(col_blue '[!]') -> Installing paru"
  install_paru
  echo -ne "$(col_blue '[!]') -> Installing Packages"
  install_packages
  echo -ne "$(col_blue '[!]') -> Installing Neovim and LazyVim"
  install_vim
  echo -ne "$(col_blue '[!]') -> Installing Fonts"
  install_fonts
  echo -ne "$(col_blue '[!]') -> Installing Touchpad Gestures"
  install_touch_pad
  echo -ne "$(col_blue '[!]') -> Creating Symbolic Links"
  create_symlinks
}

# Execute the main function
main
