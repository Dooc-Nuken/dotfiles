#bin/bash

pacman -Syu
paccache -r
pacman -Qtdq | sudo pacman -Rns -
find .cache -type d -empty -delete
find ~/.cache/ -type f -atime +30 -delete
sudo journalctl --vacuum-size=50M
echo -n Taking out teh trash | pv -qL 10 && rm -rf  ~/.local/share/Trash/files'
yay -Yc
