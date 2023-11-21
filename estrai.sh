#!/bin/bash
cd $HOME/itchbox
DESKTOPPATH=$(cat $HOME/.config/user-dirs.dirs | grep DESKTOP | awk -F "/" '{print $2}' | sed -e 's/"//g')
NOME=$(ls -1 download/ | head -1)
NOMEDIR=$(ls -1 download/ | head -1 | sed -e "s/.zip//g" -e "s/.tar.gz//g")
NOMEICONA=$(ls -1 download/ | head -1 | sed -e "s/.zip//g" -e "s/.tar.gz//g" | awk -F "Linux|LINUX|linux" '{print $1}' | sed -e 's/-//g' | sed -e 's/_//g' | sed -e 's/[0-9]//g')
FORMATO=$(file --mime-type "download/$NOME" | awk -F ":" '{print $2}' | awk -F "/" '{print $2}')

if [[ -z $NOME ]]
then 
    echo "Nessun nuovo gioco in download"
    exit 1
fi

echo $NOME
echo $FORMATO

if [[ $FORMATO == "zip" ]]
then
    echo "Scompatto il pacchetto .zip"
    unzip -o "download/$NOME" -d "games/$NOMEDIR"
elif [[ $FORMATO == "gzip" ]]
then
    echo "Scompatto il pacchetto .tar.gz"
    mkdir "games/$NOMEDIR"
    tar -zxvf "download/$NOME" -C "games/$NOMEDIR"
elif [[ $FORMATO == "x-bzip2" ]]
then
    echo "Scompatto il pacchetto .bzip2"
    mkdir "games/$NOMEDIR"
    tar -xvjf "download/$NOME" -C "games/$NOMEDIR"
elif [[ $FORMATO == "rar" ]]
then
    echo "Scompatto il pacchetto .rar"
    mkdir "games/$NOMEDIR"
    unrar "download$NOME" "games/$NOMEDIR"
fi

rm "download/$NOME"

if [[ $(file "games/$NOMEDIR"/* | grep -v directory | wc -l) = 0 ]]
then
    SOTTODIR=`ls "games/$NOMEDIR/"`
    PATHGIOCO="games/$NOMEDIR/$SOTTODIR"
    #ESEGUIBILE=`file --mime-type "$PATHGIOCO"/* | grep "application/x-executable\|text/x-shellscript"  | cut -d ":" -f 1`
else
    #ESEGUIBILE=`file --mime-type "games/$NOMEDIR"/* | grep "application/x-executable\|text/x-shellscript" | cut -d ":" -f 1`
    PATHGIOCO="games/$NOMEDIR"
fi

echo $PATHGIOCO

if [[ $(file --mime-type "$PATHGIOCO"/* | grep "text/x-shellscript") ]]
then
    ESEGUIBILE=`file --mime-type "$PATHGIOCO"/* | grep "text/x-shellscript"  | cut -d ":" -f 1`
    echo "Script shell"
elif [[ $(file --mime-type "$PATHGIOCO"/* | grep "application/x-executable") ]]
    then
    echo "Eseguibile binario"
    if [[ $(file --mime-type "$PATHGIOCO"/* | grep "application/x-executable" | wc -l) > 1 ]]
    then
        ESEGUIBILE=`file --mime-type "$PATHGIOCO"/* | grep "application/x-executable" | grep x86_64 | cut -d ":" -f 1`
        echo "Eseguibile x86"
    elif [[ $(file --mime-type "$PATHGIOCO"/* | grep "application/x-executable" | wc -l) = 1 ]]
    then
        ESEGUIBILE=`file --mime-type "$PATHGIOCO"/* | grep "application/x-executable" | cut -d ":" -f 1`
        echo "Eseguibile generico"
	sleep 3
    fi
fi

echo $ESEGUIBILE

echo "Setto il permesso +x all'eseguibile"
chmod 755 "$ESEGUIBILE"

echo "Scarico l'icona del gioco"
echo $NOMEICONA
NOMERICERCA=`echo $NOMEICONA | sed -e 's/\ /+/g'`
URL=$(curl --silent https://itch.io/search?q=$NOMERICERCA | awk -F "data-lazy_src" '{print $2}' | awk -F "\"" '{print $2}' | grep https)
if [ -v $URL ];
then
        echo "nessuna immagine trovata"
	NOMEFILE="noimage.png"
else
        echo "Scarico il file"
        NOMEFILE=$(basename $URL)
        curl -o data/$NOMEFILE $URL
fi


echo "Creo il collegamento"
echo "$NOMEICONA,\"$ESEGUIBILE\",$NOMEFILE" >> data/lista.csv
echo "[Desktop Entry]" > "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Version=1.0" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Type=Application" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Name=$NOMEICONA"  >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Comment=$NOMEICONA" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Exec=\"$HOME/itchbox/$ESEGUIBILE\"" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Icon=$HOME/itchbox/data/itchbox128.png" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Path=" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Terminal=false" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "StartupNotify=false" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "GenericName=$NOMEDIR"  >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"


echo "Setto il permesso +x al collegamento"
chmod 755 "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
