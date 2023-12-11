#!/bin/bash
clear
if [[ -z $1 ]]
then
	echo -e "\033[0;31mLista giochi installati:\033[0;36m"
	echo 
	cat $HOME/itchbox/data/lista.csv | grep -v "Aggiorna" | grep -v "Spegni" | awk -F "," '{print $1}'
	exit 1
fi
if [[ -z `cat data/lista.csv | grep "$1"` ]]
then
	echo "Nessun gioco installato con questo nome"
	exit 1
fi

echo -e "\033[0;31mDisinstallo il gioco:\033[0;36m $1"
DESKTOPPATH=$(cat $HOME/.config/user-dirs.dirs | grep DESKTOP | awk -F "/" '{print $2}' | sed -e 's/"//g')
PATHGAME=`cat data/lista.csv | grep -i "$1" | head -1 | awk -F "," '{print $2}' | awk -F "/" '{print $1"/"$2}'`
NOMEICONA=`echo "$PATHGAME" | awk -F "/" '{print $2}'`
echo $1
echo $NOMEICONA
echo $PATHGAME
echo $NOMEICONA

echo -e "\033[0;31mRimuovo la directory del gioco\033[0;36m"
rm -vrf "$PATHGAME"
echo -e "\033[;31mRimuovo il file dell'icona\033[0;36m"
rm -v `cat $HOME/$DESKTOPPATH/$NOMEICONA.desktop | grep Icon | awk -F "=" '{print $2}'`
echo -e "\033[0;31mRimuovo il collegamento\033[0;36m"
rm -v "$HOME/$DESKTOPPATH/$NOMEICONA.desktop"
echo -e "\033[0;31mRimuovo il riferimento nel registro\033[0;36m"
sed -i "/$1/d" $HOME/itchbox/data/lista.csv 
