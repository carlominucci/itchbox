#!/bin/bash

echo "Disinstallo il gioco: $1"
DESKTOPPATH=$(cat $HOME/.config/user-dirs.dirs | grep DESKTOP | awk -F "/" '{print $2}' | sed -e 's/"//g')
PATHGAME=`cat data/lista.csv | grep $1 | awk -F "\"" '{print $2}' | head -1`
NOME=`basename $PATHGAME`
echo $PATHGAME
echo $NOME

echo "Rimuovo la directory del gioco"
rm -v $PATHGAME
echo "Rimuovo il collegamento"
rm -v $HOME/$DESKTOPPATH/$NOME.desktop
