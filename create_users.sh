#!/bin/bash

# Kontrollerar att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du måste vara root för att köra detta script"
    exit 1
fi

for user in "$@"
do
    # Enkel check om användaren redan finns
    if id "$user"; then
        echo "Användaren $user finns redan"
        continue
    fi

    useradd -m "$user"

    mkdir -p /home/"$user"/Documents
    mkdir -p /home/"$user"/Downloads
    mkdir -p /home/"$user"/Work

    chown "$user":"$user" /home/"$user"

    chmod 700 /home/"$user"
    chmod 700 /home/"$user"/Documents
    chmod 700 /home/"$user"/Downloads
    chmod 700 /home/"$user"/Work

    echo "Välkommen $user" > /home/"$user"/welcome.txt
    echo "Andra användare i systemet:" >> /home/"$user"/welcome.txt

    cut -d: -f1 /etc/passwd | grep -v "^$user$" >> /home/"$user"/welcome.txt
done
