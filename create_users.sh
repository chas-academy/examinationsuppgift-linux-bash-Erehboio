#!/bin/bash

# Kontrollerar att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du behöver vara root för att köra detta script"
    exit 1
fi

# Loopar igenom alla användare som skickas in som argument
for user in "$@"
do
    # Skapa användare
    useradd -m "$user"

    # Skapa katalogstruktur
    mkdir -p /home/"$user"/Documents
    mkdir -p /home/"$user"/Downloads
    mkdir -p /home/"$user"/Work

    # Sätt ägare på hela hemkatalogen
    chown -R "$user:$user" /home/"$user"

    # Endast ägaren ska ha åtkomst
    chmod 700 /home/"$user"
    chmod 700 /home/"$user"/Documents
    chmod 700 /home/"$user"/Downloads
    chmod 700 /home/"$user"/Work

    # Skapa welcome-fil
    echo "Välkommen $user" > /home/"$user"/welcome.txt
    echo "Andra användare i systemet:" >> /home/"$user"/welcome.txt

    # Lägg till alla andra användare (filtrera bort systemkonton)
    cut -d: -f1 /etc/passwd | grep -E "^[a-zA-Z]" | grep -v "^$user$" >> /home/"$user"/welcome.txt

done
