#! /bin/bash


# fresh-install after pacstrap
# Assuming it already has:
# vim, git, devetools, base devel
green='\e[32m'
blue='\e[34m'
Clear='\e[0m'

install_aur() {
  cd 
  mkdir Sources 
  cd Sources 
  git clone https://aur.archlinux.org/yay.git
  cd yay 
  makepkg -si
}

ColGreen() {
  echo -ne "$green$*$Clear"
}

ColBlue() {
  echo -ne "$blue$*$Clear"
}

# INSTALL PACKAGES
install_packages() {
  sudo pacman -S fzf rustup nodejs npm gdm sddm python-pywal rofi calc lxappearance 
  yay -S networkmanager-dmenu-bluetoothfix-git 
}


install_vim() {
  sudo pacman -S neovide neovim
  git clone https://github.com/NvChad/starter ~/.config/nvim
}

install_fonts() {
  sudo pacman -S ttf-firacode-nerd ttf-font-awesome ttf-material-design-iconic-font ttf-fantasque-sans-mono noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-dejavu ttf-liberation ttf-opensans
  yay -S ttf-ms-win10-auto ttf-ms-win11-auto otf-apple-fonts 

  echo "[!] --> Enabling ClearType"
  yay -S freetype2
  sudo echo 'export FREETYPE_PROPERTIES="truetype:interpreter-version=40"' >> /etc/profile.d/freetype2.sh
  
  mkdir -p ~/.config/fontconfig/conf.d/
  echo '<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <match target="font">
    <edit name="embeddedbitmap" mode="assign">
      <bool>false</bool>
    </edit>
  </match>
</fontconfig>' > ~/.config/fontconfig/conf.d/20-no-embedded.conf 

  fc-cache -vc 
}


install_touch_pad() {
  sudo pacman -S xdotool wmctrl
  yay -S libinput-gestures

  sudo gpasswd -a $USER input
}

main() {
  echo -ne "$(ColBlue '[!]') -> Installing AUR"  
  install_aur
  echo -ne "$(ColBlue '[!]') -> Installing Packages"  
  install_packages
  echo -ne "$(ColBlue '[!]') -> Installing Vim"  
  install_vim
  
  echo -ne "$(ColBlue '[!]') -> Installing Fonts"  
  install_fonts
  cp ~/.A/fontconfig/fonts.conf ~/.config/fontconfig/ 

  echo -ne "$(ColBlue '[!]') -> Installing Touchpad Gestures"  
  install_touch_pad
  echo -ne "$(ColBlue '[!]') -> Moving stuff to .config "  

  cp -r ~/.A/picom/ ~/.config  
  cp -r ~/.A/kitty/ ~/.config 
  cp -r ~/.A/i3/ ~/.config 
  cp -r ~/.A/rofi/ ~/.config 
  cp -r ~/.A/libinput-gestures.conf ~/.config 
  cp -r ~/.A/polybar/ ~/.config/ 
  cp ~/.A/.Xresources ~/.Xresources
  cp -r ~/.A/.oh-my-zsh/ ~/.oh-my-zsh/
  cp ~/.A/.zshrc ~/.zshrc 
}


main
