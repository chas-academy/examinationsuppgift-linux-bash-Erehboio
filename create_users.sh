#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Du måste vara root"
    exit 1
fi

for user in "$@"
do
    useradd -m "$user"

    home="/home/$user"

    mkdir -p "$home/Documents"
    mkdir -p "$home/Downloads"
    mkdir -p "$home/Work"

    chown -R "$user:$user" "$home"

    chmod 700 "$home"
    chmod 700 "$home/Documents"
    chmod 700 "$home/Downloads"
    chmod 700 "$home/Work"

    echo "Välkommen $user" > "$home/welcome.txt"
    echo "Andra användare i systemet:" >> "$home/welcome.txt"

    for u in "$@"
    do
        if [ "$u" != "$user" ]; then
            echo "$u" >> "$home/welcome.txt"
        fi
    done

done
