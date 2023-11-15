#!/bin/bash
clear
echo "*****-----> Installo il core system di itchbox..."
cd
echo
echo "*****----->Creo le cartelle di sistema..."
echo
mkdir $HOME/itchbox
mkdir $HOME/itchbox/data
mkdir $HOME/itchbox/download
mkdir $HOME/itchbox/games
echo
echo "*****-----> Scarico e installo curl..."
echo
sudo apt -y install curl
echo
echo "*****-----> Sarico i sorgenti di joymap..."
echo
curl -O https://raw.githubusercontent.com/wizlab-it/joymap/master/joymap.c 
echo
echo "*****-----> Installo le dipendenze e il compilatore..."
echo
sudo apt -y install libxdo-dev
sudo apt -y install gcc
echo
echo "*****-----> Compilo joypad e rimuovo i sorgenti..."
echo
gcc joymap.c -lxdo -o $HOME/itchbox/data/joymap
rm joymap.c
echo
echo "*****-----> Scarico le altre parti del core system..."
echo
curl --output $HOME/itchbox/estrai.sh --url https://raw.githubusercontent.com/carlominucci/itchbox/main/estrai.sh
curl --output $HOME/itchbox/spegni.sh --url https://raw.githubusercontent.com/carlominucci/itchbox/main//spegni.sh
curl --output $HOME/itchbox/data/sfondo.jpg --url https://raw.githubusercontent.com/carlominucci/itchbox/main/sfondo.jpg
curl --output $HOME/itchbox/data/itchbox128.png --url https://raw.githubusercontent.com/carlominucci/itchbox/main/itchbox128.png
curl --output $HOME/itchbox/joypadconf.sh --url https://raw.githubusercontent.com/carlominucci/itchbox/main/joypadconf.sh
chmod 775 $HOME/itchbox/joypadconf.sh
echo
echo "*****-----> Setto i permessi del core system..."
echo
chmod 775 $HOME/itchbox/estrai.sh
chmod 775 $HOME/itchbox/spegni.sh
echo
echo "*****-----> Scarico e installo i comandi del core system..."
echo
DESKTOPPATH=$(cat $HOME/.config/user-dirs.dirs | grep DESKTOP | awk -F "/" {'print $2'} | sed -e 's/"//g')
curl --output $DESKTOPPATH/Aggiorna.desktop --url https://raw.githubusercontent.com/carlominucci/itchbox/main/Aggiorna.desktop 
curl --output $DESKTOPPATH/Spegni.desktop --url https://raw.githubusercontent.com/carlominucci/itchbox/main/Spegni.desktop
chmod 775 $DESKTOPPATH/Aggiorna.desktop
chmod 755 $DESKTOPPATH/Spegni.desktop
sudo chmod u+s /sbin/poweroff
echo
echo "*****-----> Configuro l'avvio automatico di itchbox..."
echo
mkdir $HOME/.config/autostart/
curl --output $HOME/.config/autostart/itchbox.desktop --url https://raw.githubusercontent.com/carlominucci/itchbox/main/itchbox.desktop
chmod 755 $HOME/.config/autostart/itchbox.desktop
echo
echo "*****-----> Configuro la condivisione di rete per l'upload dei pacchetti dei giochi..."
echo
sudo apt -y install samba
sudo apt -y install samba-common
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.orig
sudo curl --output /etc/samba/smb.conf --url https://raw.githubusercontent.com/carlominucci/itchbox/main/smb.conf
echo
echo "*****-----> Inserisci la password per la cartella di rete..."
echo
sudo smbpasswd -a itchbox
sudo /etc/init.d/smbd restart
echo
echo "*****-----> Installazione completata..."
