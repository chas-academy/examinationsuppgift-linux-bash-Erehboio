#!/bin/bash

# Kontrollerar att scriptet körs som root
# Annars avbryts det direkt
if [ "$EUID" -ne 0 ]; then
      echo "Du behöver vara Root för att köra detta skript"
      exit 1
fi

# Loopar igenom alla användarnamn som skickas som argument
for user in "$@"
do
    # Skapar användaren och hemkatalog
    useradd -m "$user"

    # Skapar undermappar i användarens hemkatalog
    mkdir /home/"$user"/Documents
    mkdir /home/"$user"/Downloads
    mkdir /home/"$user"/Work

    # Sätter ägare på undermapparna så att endast användaren äger dem
    chown "$user":"$user" /home/"$user"/Documents
    chown "$user":"$user" /home/"$user"/Downloads
    chown "$user":"$user" /home/"$user"/Work

    # Sätter rättigheter så att endast ägaren har full åtkomst
    chmod 700 /home/"$user"
    chmod 700 /home/"$user"/Documents
    chmod 700 /home/"$user"/Downloads
    chmod 700 /home/"$user"/Work

    # Skapar en välkomstfil i användarens hemkatalog
    echo "Välkommen $user" > /home/"$user"/welcome.txt

    # Lägger till lista över andra användare i systemet
    cut -d: -f1 /etc/passwd | grep -v "^$user$" >> /home/"$user"/welcome.txt
done
