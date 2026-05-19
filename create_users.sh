#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du behöver vara root"
    exit 1
fi

for user in "$@"
do
    if ! id "$user" >/dev/null 2>&1; then
    useradd -m "$user"
    fi

    mkdir -p /home/"$user"/Documents
    mkdir -p /home/"$user"/Downloads
    mkdir -p /home/"$user"/Work

    chown -R "$user:$user" /home/"$user" 2>/dev/null
    chmod 700 /home/"$user"
    chmod 700 /home/"$user"/Documents
    chmod 700 /home/"$user"/Downloads
    chmod 700 /home/"$user"/Work

    echo "Välkommen $user" > /home/"$user"/welcome.txt
    echo "Andra användare i systemet:" >> /home/"$user"/welcome.txt

    cut -d: -f1 /etc/passwd | grep -v "^$user$" >> /home/"$user"/welcome.txt

done
