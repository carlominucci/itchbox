#!/bin/bash
clear
if [[ -z $1 ]]
then
	echo "Lista giochi installati:"
	echo 
	cat $HOME/itchbox/data/lista.csv | awk -F "," '{print $1}'
	exit 1
fi
echo "Disinstallo il gioco: $1"
DESKTOPPATH=$(cat $HOME/.config/user-dirs.dirs | grep DESKTOP | awk -F "/" '{print $2}' | sed -e 's/"//g')
PATHGAME=`cat data/lista.csv | grep "$1" | awk -F "\"" '{print $2}' | head -1 | awk -F "/" '{print $1 "/" $2}'`
NOMEICONA=`basename "$PATHGAME"`
NOME=`basename "$PATHGAME" | awk -F "." '{print $1}'`
echo $PATHGAME
echo $NOMEICONA
echo $NOME

echo "Rimuovo la directory del gioco"
rm -vrf "$PATHGAME"
echo "Rimuovo il collegamento"
rm -v "$HOME/$DESKTOPPATH/$NOMEICONA.desktop"
echo "Rimuovo il riferimento nel registro"
sed -i "/$1/d" $HOME/itchbox/data/lista.csv 
