#!/bin/bash

# Check if script is run as root
if [ "$(id -u)" == "0" ]; then
   echo "This script must not be run as root" 1>&2
   exit 1
fi

# Check if whiptail is available
if ! command -v whiptail >/dev/null; then
    echo "whiptail is not installed. Install it and run this script again."
    exit 1
fi

# Use whiptail to get user input
USERNAME=$(whiptail --inputbox "Enter your username" 8 78 --title "User Input" 3>&1 1>&2 2>&3)
PASSWORD=$(whiptail --passwordbox "Enter your password" 8 78 --title "User Input" 3>&1 1>&2 2>&3)

# Create a 500MB EFI partition and a root partition with the rest of the space
echo -e "g\nn\n\n\n+500M\nt\n1\nn\n\n\n\nw" | fdisk /dev/nvme0n1

# Install base system and generate fstab
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt > /mnt/etc/fstab

# List of packages to install
packages=(
    gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 wayland
    libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon 
    xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio hyprland-git wlroots gcc clang
    dunst mako cliphist pipewire wireplumber cava polkit-kde-agent qt5-wayland qt6-wayland rofi-lbonn-wayland-git
    pacseek kate marker nano-syntax-highlighting pipewire-alsa pipewire-audio pipewire-jack	pipewire-pulse	
    gst-plugin-pipewire	networkmanager network-manager-applet bluez bluez-utils	blueman brightnessctl impression 
    libreoffice-fresh
    )

# Update the system first
echo "Updating system..."
sudo pacman -Syu

# Install packages
for pkg in "${packages[@]}"
do
    echo "Installing $pkg..."
    yay -S --noconfirm "$pkg"
done

echo "All packages installed successfully."

# Prepare for the next script
sed '1,/^$/d' inst1.sh > /mnt/inst1.sh
chmod +x /mnt/inst1.sh
arch-chroot /mnt ./inst1.sh

# Create .fonts directory in the home folder
mkdir -p ~/.fonts

# Initialize pacman keyring
sudo pacman-key --init

# Update font cache
fc-cache

# Install fontconfig, anyrun-git, and emacs-gcc-wayland-devel-bin using yay
yay -S --noconfirm fontconfig anyrun-git emacs-gcc-wayland-devel-bin

# Prepare for the next script
sed '1,/^$/d' inst2.sh > /mnt/inst2.sh
chmod +x /mnt/inst2.sh
arch-chroot /mnt ./inst2.sh

# List of packages to install
packages=(
    qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects swww swaylock-effects-git
    swayidle wlogout grim slurp swappy xdg-desktop-portal-hyprland-git xdg-desktop-portal-gtk imv
    qt5-imageformats pavucontrol pamixer nwg-look kvantum qt5ct firefox thunderbird neofetch dolphin
    visual-studio-code-bin vim helix geany geany-plugins plymouth-git
)

# Update the system first
echo "Updating system..."
sudo pacman -Syu

# Install packages
for pkg in "${packages[@]}"
do
    echo "Installing $pkg..."
    yay -S --noconfirm "$pkg"
done

echo "All packages installed successfully."

# Prepare for the next script
sed '1,/^$/d' inst3.sh > /mnt/inst3.sh
chmod +x /mnt/inst3.sh
arch-chroot /mnt ./inst3.sh

# List of packages to install
packages=(
    ttf-sora zenity thefuck python-ansicolors lsd sox \
    ttf-nerd-fonts-symbols-common otf-firamono-nerd inter-font \
    ttf-fantasque-nerd noto-fonts noto-fonts-emoji ttf-comfortaa \
    ttf-jetbrains-mono-nerd ttf-icomoon-feather ttf-iosevka-nerd python-pipx \
    adobe-source-code-pro-fonts tidy mpd mpc python-pip \
    pixman pango cairo mailspring emote \
    aria2 udiskie udisks2 python-pip picom jq cantata \
    ttf-fantasque-nerd noto-fonts noto-fonts-emoji ttf-comfortaa \
    ttf-jetbrains-mono ttf-icomoon-feather xdg-desktop-portal-hyprland-git \
    ttf-jetbrains-mono-nerd ttf-icomoon-feather ttf-iosevka-nerd \
    ttf-nerd-fonts-symbols-common otf-firamono-nerd inter-font \
    parallel socat starship \
    otf-sora neovim eww-wayland \
    ttf-nerd-fonts-symbols-common otf-firamono-nerd
)
