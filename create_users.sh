#!/bin/bash

# Kontrollerar att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du måste vara root för att köra detta script"
    exit 1
fi

# Loopar igenom alla användare som skickas in
for user in "$@"
do
    # Skapa användare om den inte redan finns
    if ! id "$user" 2>/dev/null; then
        useradd -m "$user"
    fi


       # Sätter hemkatalog
    home_dir="/home/$user"

    # Skapar katalogstruktur
    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # Sätter ägare på hemkatalogen
    chown -R "$user:$user" "$home_dir"

    # Endast ägaren ska ha åtkomst
    chmod 700 "$home_dir"
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # Skapar välkomstfil
    echo "Välkommen $user" > "$home_dir/welcome.txt"
    echo "Andra användare i systemet:" >> "$home_dir/welcome.txt"

    # Lista andra användare
    cut -d: -f1 /etc/passwd | grep -v "^$user$" | sort >> "$home_dir/welcome.txt"

done
