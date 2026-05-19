#!/bin/bash

if [ "$EUID" -ne 0 ]; then
      echo "Du behöver vara Root för att köra detta skript"
      exit 1
fi

for user in "$@"
do
    useradd -m "$user"
    mkdir /home/"$user"/Documents
    mkdir /home/"$user"/Downloads
    mkdir /home/"$user"/Work

    chown "$user":"$user" /home/"$user"/Documents
    chown "$user":"$user" /home/"$user"/Downloads
    chown "$user":"$user" /home/"$user"/Work

    chmod 700 /home/"$user"/Documents
    chmod 700 /home/"$user"/Downloads
    chmod 700 /home/"$user"/Work

    echo "Välkommen $user" > /home/"$user"/welcome.txt

    cut -d: -f1 /etc/passwd | grep -v "^$user$" >> /home/"$user"/welcome.txt
done
