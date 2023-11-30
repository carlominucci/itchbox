#!/bin/bash
clear
date
ip addr show | grep "inet " | grep -v "host lo" | awk '{print "Indirizzo IP: "$2}'
df -h / | grep dev | awk '{print "Spazio su disco - Totale: "$2 " - Usato: "$3 " - Libero: "$4}'
echo -n "Giochi installati: "
cat data/lista.csv | grep -v Aggiorna | grep -v Spegni | wc -l
