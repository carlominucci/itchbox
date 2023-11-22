#!/bin/bash
DESKTOPPATH=$(cat $HOME/.config/user-dirs.dirs | grep DESKTOP | awk -F "/" '{print $2}' | sed -e 's/"//g')
clear
echo -e "\t\033[0;31m*-----------> Installo il core system di itchbox...\033[0;36m"
cd
echo -e "\t\033[0;31m**---------->Creo le cartelle di sistema...\033[0;36m"
mkdir -v $HOME/itchbox
mkdir -v $HOME/itchbox/data
mkdir -v $HOME/itchbox/download
mkdir -v $HOME/itchbox/games
echo -e "\t\033[0;31m***---------> Scarico e installo curl...\033[0;36m"
sudo apt -y install curl
echo -e "\t\033[0;31m****--------> Sarico i sorgenti di joymap...\033[0;36m"
curl -O https://raw.githubusercontent.com/wizlab-it/joymap/master/joymap.c 
echo -e "\t\033[0;31m******------> Installo le dipendenze e il compilatore...\033[0;36m"
sudo apt -y install libxdo-dev
sudo apt -y install gcc
echo -e "\t\033[0;31m******------> Compilo joypad e rimuovo i sorgenti...\033[0;36m"
gcc joymap.c -lxdo -o itchbox/data/joymap
rm joymap.c
echo -e "\t\033[0;31m*******------> Scarico le altre parti del core system...\033[0;36m"
curl --output $HOME/itchbox/estrai.sh --url https://raw.githubusercontent.com/carlominucci/itchbox/main/estrai.sh
curl --output $HOME/itchbox/data/sfondo.jpg --url https://raw.githubusercontent.com/carlominucci/itchbox/main/sfondo.jpg
curl --output $HOME/itchbox/data/itchbox128.png --url https://raw.githubusercontent.com/carlominucci/itchbox/main/itchbox128.png
curl --output $HOME/itchbox/joypadconf.sh --url https://raw.githubusercontent.com/carlominucci/itchbox/main/joypadconf.sh
chmod -v 775 $HOME/itchbox/joypadconf.sh
echo -e "\t\033[0;31m********-----> Setto i permessi del core system...\033[0;36m"
chmod -v 775 $HOME/itchbox/estrai.sh
echo -e "\t\033[0;31m*********----> Scarico e installo i comandi del core system...\033[0;36m"
curl --output $HOME/$DESKTOPPATH/Aggiorna.desktop --url https://raw.githubusercontent.com/carlominucci/itchbox/main/Aggiorna.desktop 
curl --output $HOME/$DESKTOPPATH/Spegni.desktop --url https://raw.githubusercontent.com/carlominucci/itchbox/main/Spegni.desktop
chmod -v 775 $HOME/$DESKTOPPATH/Aggiorna.desktop
chmod -v 775 $HOME/$DESKTOPPATH/Spegni.desktop
echo -e "\t\033[0;31m**********---> Configuro l'avvio automatico di itchbox...\033[0;36m"
mkdir -v $HOME/.config/autostart/
curl --output $HOME/.config/autostart/itchbox.desktop --url https://raw.githubusercontent.com/carlominucci/itchbox/main/itchbox.desktop
chmod -v 755 $HOME/.config/autostart/itchbox.desktop
echo -e "\t\033[0;31m***********--> Configuro la condivisione di rete per l'upload dei pacchetti dei giochi...\033[0;36m"
sudo apt -y install samba
sudo apt -y install samba-common
sudo mv -v /etc/samba/smb.conf /etc/samba/smb.conf.orig
sudo curl --output /etc/samba/smb.conf --url https://raw.githubusercontent.com/carlominucci/itchbox/main/smb.conf
echo -e "\t\033[0;31m************-> Inserisci la password per la cartella di rete...\033[0;36m"
sudo smbpasswd -a itchbox
sudo /etc/init.d/smbd restart
echo -e "\t\033[0;32m*************> Installazione completata...\033[0;36m"
