#!/bin/bash

# Kontrollerar att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du måste vara root för att köra detta script"
    exit 1
fi

# Loopar igenom alla användare som skickas in som argument
for user in "$@"
do
    # Skapar användaren (hoppar över om den redan finns)
    if id "$user" 2>/dev/null; then
        echo "Användaren $user finns redan"
        continue
    fi

    useradd -m "$user"

    # Skapar mappar i hemkatalogen
    mkdir "/home/$user/Documents"
    mkdir "/home/$user/Downloads"
    mkdir "/home/$user/Work"

    # Sätter ägare på hemkatalogen och mapparna
    chown -R "$user:$user" "/home/$user"

    # Endast ägaren ska ha åtkomst
    chmod 700 "/home/$user"
    chmod 700 "/home/$user/Documents"
    chmod 700 "/home/$user/Downloads"
    chmod 700 "/home/$user/Work"

    # Skapar välkomstfil
    echo "Välkommen $user" > "/home/$user/welcome.txt"
    echo "Andra användare i systemet:" >> "/home/$user/welcome.txt"

    # Lägger till alla andra användare
    cut -d: -f1 /etc/passwd | grep -v "^$user$" >> "/home/$user/welcome.txt"

done
