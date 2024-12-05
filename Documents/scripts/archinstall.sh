#!/bin/bash
clear
echo "    _             _       ___           _        _ _ "
echo "   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo " / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
echo "-----------------------------------------------------"
echo ""
# ------------------------------------------------------
#NOTE: Avant toutes chose ->
# Activer UEFI
# Desactiver SecureBoot
# Prendre la main a distance en ssh
# Faire un mdp : passwd
# ---Rappel commande ssh
# ssh root@localhost -p 2222
# ---Verification des variables EFI
# efivar -l | grep boot 
# ------------------------------------------------------


# ------------------------------------------------------
# Options de montage & variablesa
# ------------------------------------------------------
OPTS=defaults,noatime,nodiratime,ssd,compress=zstd,commit=120
#DISKS_KEY_PATH='/etc/keys'
#DISKS_KEY_FILE=/etc/keys'/disks.key'

# ------------------------------------------------------
# Partitionnement du DISQUE
# ------------------------------------------------------
# Disque 1 : EFI, systèmes, début des données
# Pour lister les disks
# fdisk -l | grep -v loop | grep -e '^Disk /'

# TODO: Adapater le script pour tout type de disques
sgdisk --clear -n 0:0:+512MiB -t 0:ef00 -c 0:EFI /dev/nvme0n1 #EFI de 550Mo
ENDSECTOR=$(sgdisk -E /dev/nvme0n1)
sgdisk -n 0:0:"$ENDSECTOR" -t 0:8309 -c 0:SYS /dev/nvme0n1  #Le reste du systeme

# Vérifications
fdisk -l | grep -e '^/dev'
ls -l /dev/disk/by-partlabel
read -p

# ------------------------------------------------------
# Chiffrement - Opti pour SSD 8192 + opti secu
# ------------------------------------------------------
cryptsetup luksFormat \
    --type luks2 \
    --align-payload 8192 \
    --pbkdf argon2id \
    --iter-time 5000 \
    --key-size 256 \
    --cipher aes-xts-plain64 \
    --verify-passphrase \
    /dev/disk/by-partlabel/SYS
cryptsetup open /dev/disk/by-partlabel/SYS system

# ------------------------------------------------------
# Création couche LVM - optimisé pour SSD
# ------------------------------------------------------
# pvcreate --dataalignment 4M /dev/mapper/system
# vgcreate vgsys /dev/mapper/system
# lvcreate --extents +100%FREE vgsys /dev/mapper/system --name arch

# ------------------------------------------------------
# Création sousvolume BTRFS + noTRIM
# ------------------------------------------------------
# mkfs.btrfs -q --nodiscard --label ARCH /dev/vgsys/arch
# quiet et label = Arch et on force pour eviter les erreur
# Formatage Fat32 pour EFI
mkfs.vfat -F32 -n EFI /dev/disk/by-partlabel/EFI
mkfs.btrfs -q -L Arch -f /dev/mapper/system

# mount -o $OPTS /dev/mapper/vgsys-arch /mnt
mount /dev/mapper/system /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@data
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@.snapshot

chattr +C /mnt/@var

# Démontage du groupe de volume et montage du volume logique du système
umount /mnt

mount -o $OPTS,subvol=@ /dev/mapper/system /mnt
mount -o $OPTS,subvol=@home /dev/mapper/system /mnt/home
mount -o $OPTS,subvol=@data /dev/mapper/system /mnt/data
mount -o $OPTS,subvol=@var /dev/mapper/system /mnt/var
mount -o $OPTS,subvol=@log /dev/mapper/system /mnt/var/log
mount -o $OPTS,subvol=@cache /dev/mapper/system /mnt/var/cache
mount -o $OPTS,subvol=@.snapshot /dev/mapper/system /mnt/.snapshot

mount -o nodev,nosuid,noexec /dev/nvme0n1p1 /mnt/boot

df -h | grep /mnt
read -p

# ------------------------------------------------------
# Instalation sys base 
# ------------------------------------------------------
pacman-key --init && \
pacman-key --populate && \
pacman -Sy --noconfirm archlinux-keyring

pacstrap -i /mnt base base-devel linux linux-firmware btrfs-progs git go vim sudo tmux \
         refind curl zsh git sshguard bat noto-fonts kitty ttf-fira-code noto-fonts \
         noto-fonts-emoji man blueman networkmanager intel-ucode qemu-guest-agent \
         zram-generator net-tools dhcpcd openssh hdparm util-linux terminus-font less \
         tree booster
# On choisit Booster ici le reste on default

# ------------------------------------------------------
# Generation de fstab et fichier de conf
# ------------------------------------------------------
genfstab -U -p /mnt >> /mnt/etc/fstab
timedatectl set-ntp true
pacman -S zsh
cp /etc/zsh/zprofile /mnt/root/.zprofile && \
cp /etc/zsh/zshrc /mnt/root/.zshrc
arch-chroot /mnt /bin/zsh

# ------------------------------------------------------
# Setup variable - ZSH et reflector
# ------------------------------------------------------
export USER=dooc      # Replace username with the name for your new user
export HOST=vivaldi      # Replace hostname with the name for your host
export TZ="Europe/Paris" # Replace Europe/London with your Region/City

passwd && \
chsh -s /bin/zsh

pacman -S --noconfirm reflector
reflector \
  --save /etc/pacman.d/mirrorlist \
  --country France \
  --protocol https \
  --latest 10 \
  --verbose

# Optimisation du fichier de configuration pacman (optionnel)
sed -i 's/^#Color$/Color/' /etc/pacman.conf
sed -i 's/^#ParallelDownloads = .$/ParallelDownloads = 4/' /etc/pacman.conf

ln -sf /usr/share/zoneinfo/$TZ /etc/localtime  && \
hwclock -uw # or hwclock --systohc --utc

# Langue
sed -i 's/^#\(fr_FR\.UTF-8\)/\1/' /etc/locale.gen
sed -i 's/^#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
echo "LC_MESSAGES=fr_FR.UTF-8" >> /etc/locale.conf

# ------------------------------------------------------
# Telechargrement du clavier custom US
# ------------------------------------------------------
sudo pacman -S wget
wget https://qwerty-lafayette.org/releases/lafayette_linux_v0.9.xkb_custom
mv lafayette_linux_v0.9.xkb_custom ${XKB_CONFIG_ROOT:-/usr/share/X11/xkb}/symbols/custom 
# xkblayout-state print "%s"


# ------------------------------------------------------
# Langue systeme - Clavier - Et options DIV 
# ------------------------------------------------------
echo "KEYMAP=us" > /etc/vconsole.conf && \
export LANG="en_US.UTF-8" && \
export LC_COLLATE="C"

echo $HOST > /etc/hostname
pacman -S neovim wl-clipboard
echo "EDITOR=neovim" >> /etc/environment

# ------------------------------------------------------
# Creation User
# ------------------------------------------------------
groupadd docker
groupadd libvirt
useradd -m -G  docker,input,kvm,libvirt,storage,video,wheel -s /bin/zsh $USER && \
passwd $USER && \
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers && \
echo "Defaults timestamp_timeout=0" >> /etc/sudoers

su $USER
cd ~  && \
git clone https://aur.archlinux.org/yay.git && \
cd yay && \
makepkg -si && \
cd .. && \
sudo rm -dR yay

# ------------------------------------------------------
# Génération des clés secure boot en user 
# ------------------------------------------------------
# TODO: A changer pour utiliser sbctl
# sbctl create-keys
# sbctl bundle --save /boot/arch-linux.efi

yay --noremovemake -S shim-signed && \
sudo refind-install --shim /usr/share/shim-signed/shimx64.efi --localkeys && \
sudo sbsign --key /etc/refind.d/keys/refind_local.key --cert /etc/refind.d/keys/refind_local.crt --output /boot/vmlinuz-linux /boot/vmlinuz-linux

# ------------------------------------------------------
# Modification HOST
# ------------------------------------------------------
cat << EOF >> /etc/hosts
# <ip-address>	<hostname.domain.org>	<hostname>
127.0.0.1	localhost
::1		localhost
127.0.1.1	$HOST.localdomain	$HOST
EOF

# ------------------------------------------------------
# Configuration ZRAM + SWAP
# ------------------------------------------------------
cat << 'EOF' > /etc/systemd/zram-generator.conf
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
EOF

# Optimisation du swap avec zram
cat << 'EOF' > /etc/sysctl.d/99-vm-zram-parameters.conf
vm.swappiness = 180
vm.watermark_boost_factor = 0
vm.watermark_scale_factor = 125
vm.page-cluster = 0
EOF

# ------------------------------------------------------
# Creation de Hook pacman et signature kernel secureboot
# ------------------------------------------------------
pacman -S sbsigntool
pacman -S fd

mkdir /etc/pacman.d/hooks && cat << EOF > /etc/pacman.d/hooks/999-sign_kernel_for_secureboot.hook
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = linux
Target = linux-lts
Target = linux-hardened
Target = linux-zen
Target = linux-xanmod
Target = linux-xanmod-cacule
Target = linux-xanmod-git
Target = linux-xanmod-lts
Target = linux-xanmod-rt
Target = linux-xanmod-anbox

[Action]
Description = Signing kernel with Machine Owner Key for Secure Boot
When = PostTransaction
Exec = /usr/bin/fd vmlinuz /boot -d 1 -x /usr/bin/sbsign --key /etc/refind.d/keys/refind_local.key --cert /etc/refind.d/keys/refind_local.crt --output {} {}
Depends = sbsigntools
Depends = fd
EOF

#Hook refind

cat << EOF > /etc/pacman.d/hooks/refind.hook
[Trigger]
Operation=Upgrade
Type=Package
Target=refind

[Action]
Description = Updating rEFInd on ESP
When=PostTransaction
Exec=/usr/bin/refind-install 
EOF
#--shim /usr/share/shim-signed/shimx64.efi --localkeys


cat << EOF > /etc/pacman.d/hooks/zsh.hook
[Trigger]
Operation = Install
Operation = Upgrade
Operation = Remove
Type = Path
Target = usr/bin/*
[Action]
Depends = zsh
When = PostTransaction
Exec = /usr/bin/install -Dm644 /dev/null /var/cache/zsh/pacman
EOF

#auto logout

cat << EOF > /etc/profile.d/shell-timeout.sh
TMOUT="\$(( 60*30 ))";
[ -z "\$DISPLAY" ] && export TMOUT;
case \$( /usr/bin/tty ) in
	/dev/tty[0-9]*) export TMOUT;;
esac
EOF

# Set les variable de ZSH 
cat << EOF > /etc/zsh/zshenv
export ZDOTDIR=$HOME/.config/zsh
export HISTFILE="$XDG_DATA_HOME"/zsh/history
EOF


# ------------------------------------------------------
# # Configuration des snapshots avec snapper
# ------------------------------------------------------
# snapper --no-dbus -c arch create-config /
# snapper --no-dbus -c home create-config /home
# snapper --no-dbus -c data create-config /data


# ------------------------------------------------------
# Activation des services
# ------------------------------------------------------
systemctl enable \
	systemd-timesyncd dhcpcd sshd \
	reflector.timer fstrim.timer \
	systemd-zram-setup@zram0.service

# ------------------------------------------------------
# REFIND THEME
# ------------------------------------------------------

yay refind-btrfs # Pour booter facilement les snapshots 

mkdir /boot/EFI/refind/themes  && \
git clone https://github.com/dheishman/refind-dreary.git /boot/EFI/refind/themes/refind-dreary-git && \
mv /boot/EFI/refind/themes/refind-dreary-git/highres /boot/EFI/refind/themes/refind-dreary && \
rm -dR /boot/EFI/refind/themes/refind-dreary-git

sed -i 's/#resolution 3/resolution 1920 1080/' /boot/EFI/refind/refind.conf && \
sed -i 's/#use_graphics_for osx,linux/use_graphics_for linux/' /boot/EFI/refind/refind.conf && \
sed -i 's/#scanfor internal,external,optical,manual/scanfor manual,external/' /boot/EFI/refind/refind.conf
sed -i 's/^hideui.*/hideui singleuser,hints,arrows,badges/' /boot/EFI/refind/themes/refind-dreary/theme.conf

cat << EOF >> /boot/EFI/refind/refind.conf

menuentry "Arch Linux" {
    icon     /EFI/refind/themes/refind-dreary/icons/os_arch.png
    volume   "Arch Linux"
    loader   /vmlinuz-linux
    initrd   /initramfs-linux.img
    options  "rd.luks.name=$(blkid /dev/nvme0n1p2 | cut -d " " -f2 | cut -d '=' -f2 | sed 's/\"//g')=crypt root=/dev/mapper/system rootflags=subvol=@ rw quiet nmi_watchdog=0 initrd=\intel-ucode.img"
    submenuentry "Boot - terminal" {
        add_options "systemd.unit=multi-user.target"
    }
}
include themes/refind-dreary/theme.conf
EOF

sed -i 's/^include_sub_menus.*/include_sub_menus = true/' /etc/refind-btrfs.conf


# installation de snap-pac pour les snapshots auto
sudo pacman --noconfirm -S snap-pac

## Create post script

cat << EOF >> /home/$USER/init.sh
sudo umount /.snapshots
sudo rm -r /.snapshots
sudo snapper -c root create-config /
sudo mount -a
sudo chmod 750 -R /.snapshots
sudo chmod a+rx /.snapshots
sudo chown :wheel /.snapshots
sudo snapper -c root create --description "Fresh Install"
sudo sed -i 's/^TIMELINE_MIN_AGE.*/TIMELINE_MIN_AGE="1800"/' /etc/snapper/configs/root && \
sudo sed -i 's/^TIMELINE_LIMIT_HOURLY.*/TIMELINE_LIMIT_HOURLY="0"/' /etc/snapper/configs/root && \
sudo sed -i 's/^TIMELINE_LIMIT_DAILY.*/TIMELINE_LIMIT_DAILY="7"/' /etc/snapper/configs/root && \
sudo sed -i 's/^TIMELINE_LIMIT_WEEKLY.*/TIMELINE_LIMIT_WEEKLY="0"/' /etc/snapper/configs/root && \
sudo sed -i 's/^TIMELINE_LIMIT_MONTHLY.*/TIMELINE_LIMIT_MONTHLY="0"/' /etc/snapper/configs/root && \
sudo sed -i 's/^TIMELINE_LIMIT_YEARLY.*/TIMELINE_LIMIT_YEARLY="0"/' /etc/snapper/configs/root
sudo systemctl enable --now snapper-timeline.timer snapper-cleanup.timer
sudo systemctl disable --now systemd-timesyncd.service
sudo systemctl mask systemd-rfkill.socket systemd-rfkill.service
sudo systemctl enable --now NetworkManager 
sudo systemctl enable --now NetworkManager-wait-online
sudo systemctl enable --now NetworkManager-dispatcher
sudo systemctl enable --now nftables
sudo systemctl enable --now opennic-up.timer
sudo systemctl enable --now sshd 
sudo systemctl enable --now chronyd
sudo systemctl enable --now reflector
sudo systemctl enable --now apparmor 
sudo systemctl enable --now sshguard
sudo systemctl enable --now tlp 
sudo systemctl enable --now memavaild 
sudo systemctl enable --now haveged 
sudo systemctl enable --now irqbalance 
sudo systemctl enable --now prelockd 
sudo systemctl enable --now systemd-swap 
sudo systemctl enable --now nohang-desktop 
sudo systemctl enable --now auto-cpufreq 
sudo systemctl enable --now dbus-broker
sudo systemctl enable --now postgresql
sudo systemctl enable --now refind-btrfs
systemctl --user start psd
sudo systemctl enable --now gdm
rm /home/$USER/init.sh
EOF
chown $USER /home/$USER/init.sh

# FIN du carnage 
exit
umount -R /mnt && \
reboot
