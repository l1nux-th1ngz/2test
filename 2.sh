# Continue from inst4.sh on a new file
#!/bin/bash

# List of packages to install
packages=(
    inter-font parallel socat starship otf-sora neovim eww-wayland \
    ttf-nerd-fonts-symbols-common otf-firamono-nerd inter-font \
    ttf-fantasque-nerd noto-fonts noto-fonts-emoji ttf-comfortaa \
    ttf-jetbrains-mono-nerd ttf-icomoon-feather ttf-iosevka-nerd \
    adobe-source-code-pro-fonts ttf-ms-win11-auto adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts \
    ttf-jetbrains-mono otf-font-awesome nerd-fonts-sf-mono \
    otf-nerd-fonts-monacob-mono ttf-font-awesome light brillo \
    mint-themes yad impression \
    fish spicetify zsh playerctl spotify noise-suppression-for-voice \
    exa spotify-adblock-git tumbler \
    oh-my-zsh spicetify-themes-git util-linux-libs \
    zsh-theme-powerlevel10k compiler-rt \
    zsh-syntax-highlighting python-compile blueman-applet \
    zsh-autosuggestions spicetify-marketplace-bin \
    pokemon-colorscripts-git genius-spicetify-git
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

# Enable TRIM
sudo systemctl enable fstrim.timer

# Clone and install Proxzima Plymouth theme
git clone https://aur.archlinux.org/proxzima-plymouth-git.git && cd proxzima-plymouth && sudo cp -r proxzima /usr/share/plymouth/themes && sudo plymouth-set-default-theme -R proxzima

# Enable Plymouth
sudo systemctl enable plymouth

# Download and install Nerd Font
curl -fLo "<FONT_NAME> Nerd Font Complete.otf" \
https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/<FONT_PATH>/complete/<FONT_NAME>%20Nerd%20Font%20Complete.otf

# Backup the original pacman.conf file
sudo cp /etc/pacman.conf /etc/pacman.conf.bak

# Write the new configuration to pacman.conf
sudo bash -c 'cat > /etc/pacman.conf' << EOF
#
# /etc/pacman.conf
#
# See the pacman.conf(5) manpage for option and repository directives

#
# GENERAL OPTIONS
#
[options]
# The following paths are commented out with their default values listed.
# If you wish to use different paths, uncomment and update the paths.
#RootDir     = /
#DBPath      = /var/lib/pacman/
#CacheDir    = /var/cache/pacman/pkg/
#LogFile     = /var/log/pacman.log
#GPGDir      = /etc/pacman.d/gnupg/
#HookDir     = /etc/pacman.d/hooks/
HoldPkg     = pacman glibc
#XferCommand = /usr/bin/curl -L -C - -f -o %o %u
#XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
#CleanMethod = KeepInstalled
Architecture = auto

# Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
#IgnorePkg   =
#IgnoreGroup =

#NoUpgrade   =
#NoExtract   =

# Misc options
#UseSyslog
Color
Ilovecandy
#NoProgressBar
CheckSpace
VerbosePkgLists
ParallelDownloads = 20
EOF

# Prepare for the next script
cat <<EOF > /mnt/inst5.sh

#!/bin/bash

# Ask for username and password only once at the beginning
USERNAME=$(whiptail --inputbox "Enter your username" 8 78 --title "User Input" 3>&1 1>&2 2>&3)
PASSWORD=$(whiptail --passwordbox "Enter your password" 8 78 --title "User Input" 3>&1 1>&2 2>&3)

# Backup the original grub configuration file
sudo cp /etc/default/grub /etc/default/grub.bak

# Write the new configuration to grub
sudo bash -c 'cat > /etc/default/grub' << EOF
# GRUB boot loader configuration
...
EOF

# Update grub configuration
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Prepare for the next script
sed '1,/^$/d' inst4.sh > /mnt/inst4.sh
chmod +x /mnt/inst4.sh

# Run the next script
arch-chroot /mnt ./inst4.sh

# Reboot the system after the script finishes
sudo reboot
