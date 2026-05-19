#!/bin/bash

# Kontrollerar att scriptet körs som root.
if [ "$EUID" -ne 0 ]; then
    echo "Du måste vara root för att köra detta script"
    exit 1
fi

# Loopar igenom alla användare som skickas in som argument.
for user in "$@"
do
    # Check om användaren redan finns.
    if id "$user"; then
        echo "Användaren $user finns redan"
        continue
    fi

    useradd -m "$user"

    # Skapar mappar i hemkatalogen
    mkdir -p "/home/$user/Documents"
    mkdir -p "/home/$user/Downloads"
    mkdir -p "/home/$user/Work"

    # Sätter rätt ägare för hela deras hemkatalog.
    chown -R "$user:$user" "/home/$user"

    # Ser till att endast ägaren har åtkomst.
    chmod 700 "/home/$user"
    chmod 700 "/home/$user/Documents"
    chmod 700 "/home/$user/Downloads"
    chmod 700 "/home/$user/Work"

    # Skapar välkomstfil
    echo "Välkommen $user" > "/home/$user/welcome.txt"
    echo "Andra användare i systemet:" >> "/home/$user/welcome.txt"

    # Lägger till alla andra användare utan den användaren som skapades själv.
    cut -d: -f1 /etc/passwd | grep -v "^$user$" >> "/home/$user/welcome.txt"

done
