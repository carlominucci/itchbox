#!/bin/bash
echo "*****-----> Installo il core system di itchbox..."
cd
echo "*****----->Creo le cartelle di sistema..."
mkdir itchbox
mkdir itchbox/data
mkdir itchbox/download
mkdir itchbox/games
echo "*****-----> Scarico e installo wget..."
sudo apt -y install curl
echo "*****-----> Sarico i sorgenti di joymap..."
curl -O https://raw.githubusercontent.com/wizlab-it/joymap/master/joymap.c 
echo "*****-----> Installo le dipendenze e il compilatore..."
sudo apt -y install libxdo-dev
sudo apt -y install gcc
echo "*****-----> Compilo joypad e rimuovo i sorgenti..."
gcc joymap.c -lxdo -o itchbox/data/joymap
rm joymap.c
echo "*****-----> Scarico le altre parti del core system..."
curl --output itchbox/estrai.sh --url https://minucci.net/itchbox/estrai.sh
curl --output itchbox/spegni.sh --url https://minucci.net/itchbox/spegni.sh
curl --output itchbox/data/sfondo.jpg --url https://minucci.net/itchbox/sfondo.jpg
echo "*****-----> Setto i permessi del core system..."
chmod 775 itchbox/estrai.sh
chmod 775 itchbox/spegni.sh
echo "*****-----> Scarico e installo i comandi del core system..."
curl --output Desktop/ --url https://minucci.net/itchbox/Aggiorna.desktop
curl --output Desktop/ --url https://minucci.net/itchbox/Spegni.desktop
chmod 775 Desktop/Aggiorna.desktop
chmod 755 Desktop/Spegni.desktop
echo "*****-----> Configuro l'avvio automatico di itchbox..."
mkdir .config/autostart
curl --output .config/autostart/itchbox.desktop --url https://minucci.net/itchbox/itchbox.desktop
chmod 755 ./confif/autostart/itchbox.desktop
echo "*****-----> Configuro la condivisione di rete per l'upload dei pacchetti dei giochi..."
sudo apt -y install samba
sudo apt -y install samba-common
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.orig
sudo --output /etc/samba/smb.conf --url https://minucci.net/itchbox/smb.conf
echo "*****-----> Inserisci la password per la cartella di rete..."
sudo /etc/init.d/smbd restart
echo "*****-----> Installazione completata..."
