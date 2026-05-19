#!/bin/bash

# Kontrollerar att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du behöver vara root för att köra detta script"
    exit 1
fi

# Loopar igenom alla användare som skickas in som argument
for user in "$@"
do
    # Skapar användaren (hoppar över om den redan finns)
    if id "$user" 2>/dev/null; then
        continue
    fi

    useradd -m "$user"

    # Skapar katalogstruktur i hemkatalogen
    mkdir -p /home/"$user"/Documents
    mkdir -p /home/"$user"/Downloads
    mkdir -p /home/"$user"/Work

    # Sätter ägare på hemkatalogen och allt innehåll
    chown -R "$user:$user" /home/"$user"

    # Sätter rättigheter så endast ägaren har åtkomst
    chmod 700 /home/"$user"
    chmod 700 /home/"$user"/Documents
    chmod 700 /home/"$user"/Downloads
    chmod 700 /home/"$user"/Work

    # Skapar välkomstfil
    echo "Välkommen $user" > /home/"$user"/welcome.txt
    echo "Andra användare i systemet:" >> /home/"$user"/welcome.txt

    # Lägger till andra användare i systemet (utan current user)
    getent passwd | cut -d: -f1 | grep -v "^$user$" >> /home/"$user"/welcome.txt

done
