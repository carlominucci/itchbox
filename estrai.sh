#!/bin/bash
cd $HOME/itchbox
DESKTOPPATH=$(cat $HOME/.config/user-dirs.dirs | grep DESKTOP | awk -F "/" '{print $2}' | sed -e 's/"//g')
NOME=$(ls -1 download/ | head -1)
#NOMEDIR=$(ls -1 download/ | head -1 | sed -e "s/.zip//g" -e "s/.tar.gz//g")
NOMEICONA=$(ls -1 download/ | head -1 | awk -F "." '{print $1}' | sed -e "s/.zip//g" -e "s/.tar.gz//g" -e "s/.tar.bz2//g" | awk -F "Linux|LINUX|linux" '{print $1}' | sed -e 's/-/ /g' | sed -e 's/_//g' | sed -e 's/[0-9]//g' | sed -e 's/\.//g' | sed -e 's/\[//g' | sed -e 's/\s*$//')
FORMATO=$(file --mime-type "download/$NOME" | awk -F ":" '{print $2}' | awk -F "/" '{print $2}')

if [[ -z $NOME ]]
then 
    echo -e "\033[0;31mNessun nuovo gioco in download"
    exit 1
fi

echo -e "\033[0;32mTrovato un nuovo gioco: \033[0;37m$NOME"

if [[ -z $(file download/$NOME | grep exe) ]]
then
	echo "File compresso"	
	NOMEDIR=$(ls -1 download/ | head -1 | sed -e "s/.zip//g" -e "s/.tar.gz//g" -e "s/.tar.bz2//g")

	if [[ $FORMATO == "zip" ]]
	then
    		echo -e "\033[0;33mScompatto il pacchetto .zip"
    		unzip -o "download/$NOME" -d "games/$NOMEDIR"
	elif [[ $FORMATO == "gzip" ]]
	then
    		echo -e "\033[0;34mScompatto il pacchetto .tar.gz"
		mkdir -v "games/$NOMEDIR"
    		tar -zxvf "download/$NOME" -C "games/$NOMEDIR"
	elif [[ $FORMATO == "x-bzip2" ]]
	then
    		echo -e "\033[0;35mScompatto il pacchetto .bzip2"
    		mkdir -v "games/$NOMEDIR"
    		tar -xvjf "download/$NOME" -C "games/$NOMEDIR"
	elif [[ $FORMATO == "rar" ]]
	then
    		echo -e "\033[0;36mScompatto il pacchetto .rar"
    		mkdir -v "games/$NOMEDIR"
    		unrar "download$NOME" "games/$NOMEDIR"
	fi

	rm -rfv "games/$NOMEDIR/__MACOSX/"
	
	if [[ $(file "games/$NOMEDIR"/* | grep -v directory | wc -l) = 0 ]]
        then
                SOTTODIR=`ls "games/$NOMEDIR/"`
                PATHGIOCO="games/$NOMEDIR/$SOTTODIR"
        else
                PATHGIOCO="games/$NOMEDIR"
        fi

	echo -e "\033[0;32mDetermino il tipo di eseguibile: \033[0;37m$PATHGIOCO"

	if [[ $(file --mime-type "$PATHGIOCO"/* | grep "text/x-shellscript") ]]
	then
    		ESEGUIBILE=`file --mime-type "$PATHGIOCO"/* | grep "text/x-shellscript"  | cut -d ":" -f 1`
    		echo -e "\033[0;33mScript shell"
	elif [[ $(file --mime-type "$PATHGIOCO"/* | grep "application/x-executable") ]]
    		then
    			echo -e "\033[0;34mEseguibile binario"
    		if [[ $(file --mime-type "$PATHGIOCO"/* | grep "application/x-executable" | wc -l) > 1 ]]
    		then
        		ESEGUIBILE=`file --mime-type "$PATHGIOCO"/* | grep "application/x-executable" | grep x86_64 | cut -d ":" -f 1`
        		echo -e "\033[0;35mEseguibile x86"
    		elif [[ $(file --mime-type "$PATHGIOCO"/* | grep "application/x-executable" | wc -l) = 1 ]]
    		then
        		ESEGUIBILE=`file --mime-type "$PATHGIOCO"/* | grep "application/x-executable" | cut -d ":" -f 1`
        		echo -e "\033[0;36mEseguibile generico"
		fi
	fi

	echo -e "\033[0;32mSetto il permesso +x all'eseguibile\033[0;36m"
	chmod -v 755 "$ESEGUIBILE"
	echo $NOME
	rm -v "download/$NOME"


elif [[ -z $(file download/$NOME | grep compress) ]]
then	
	echo "File eseguibile o immagine"
	echo $NOME
	NOMEDIR=`ls -1 download/ | head -1 | awk -F "." '{print $1}'`
	echo $NOMEDIR
	echo "Creo la cartella per il gioco"
	mkdir -v games/$NOMEDIR
	echo "Ci copio l'eseguibile"
	cp -v download/$NOME games/$NOMEDIR
	echo "Setto i permessi dell'eseguibile"
	chmod -v 755 games/$NOMEDIR/$NOME
	rm -v download/$NOME
	ESEGUIBILE=game/$NOMEDIR/$NOME
fi

echo -e "\033[0;32mScarico l'icona del gioco: \033[0;37m$NOMEICONA"
NOMERICERCA=`echo $NOMEICONA | sed -e 's/\ /+/g'`
URL=$(curl --silent https://itch.io/search?q=$NOMERICERCA | awk -F "data-lazy_src" '{print $2}' | awk -F "\"" '{print $2}' | grep https)
if [ -v $URL ];
then
        echo -e "\033[0;31mnessuna immagine trovata"
	NOMEFILE="noimage.png"
else
        echo -e "\033[0;32mScarico il file dell'icona"
        NOMEFILE=$(basename $URL)
        curl -o data/$NOMEFILE $URL
fi

echo -e "\033[0;32mCreo il collegamento\033[0;37m"
echo "$NOMEICONA,$ESEGUIBILE,$NOMEFILE" >> data/lista.csv
echo "[Desktop Entry]" > "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Version=1.0" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Type=Application" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Name=$NOMEICONA"  >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Comment=$NOMEICONA" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Exec=\"$HOME/itchbox/$ESEGUIBILE\"" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Icon=$HOME/itchbox/data/$NOMEFILE" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Path=" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "Terminal=false" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "StartupNotify=false" >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
echo "GenericName=$NOMEDIR"  >> "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"


echo -e "\033[0;32mSetto il permesso +x al collegamento\033[0;36m"
chmod -v 755 "$HOME/$DESKTOPPATH/$NOMEDIR.desktop"
