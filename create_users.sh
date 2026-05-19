#!/bin/bash

#kontrollera att skriptet körs i root

if [ "$EUID" -ne 0 ]; then
    echo "Du måste vara root för att köra detta script."
    exit 1
fi

#loopa igenom användare som skickades in
for user in "$@"
do
    # Skapa användare med hemkatalog
    useradd -m "$user"

    # ======================================
    # Skapa katalogstruktur för användaren
    # ======================================
        mkdir /home/"$user"/Documents
        mkdir /home/"$user"/Downloads
        mkdir /home/"$user"/Work

    # Sätt ägare till användaren
        chown "$user":"$user" /home/"$user"/Documents
        chown "$user":"$user" /home/"$user"/Downloads
        chown "$user":"$user" /home/"$user"/Work

    # Sätt rättigheter (endast ägare har access)
        chmod 700 /home/"$user"/Documents
        chmod 700 /home/"$user"/Downloads
        chmod 700 /home/"$user"/Work

    # ======================================
    # Skapa welcome-fil
    # ======================================
        echo "Welcome $user" > /home/"$user"/welcome.txt
        chown "$user":"$user" /home/"$user"/welcome.txt

    # Hämta alla systemanvändare
    cut -d: -f1 /etc/passwd | grep -v "^$user$" >> /home/"$user"welcome.txt

    done
