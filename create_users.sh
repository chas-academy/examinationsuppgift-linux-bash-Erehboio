#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Du behöver vara root"
    exit 1
fi

for user in "$@"
do
    useradd -m "$user"
done

    HOME_DIR=$(eval echo "~$user")

    mkdir -p "$HOME_DIR/Documents"
    mkdir -p "$HOME_DIR/Downloads"
    mkdir -p "$HOME_DIR/Work"

    chown -R "$user:$user" "$HOME_DIR"

    chmod 700 "$HOME_DIR"
    chmod 700 "$HOME_DIR/Documents"
    chmod 700 "$HOME_DIR/Downloads"
    chmod 700 "$HOME_DIR/Work"

    echo "Välkommen $user" > "$HOME_DIR/welcome.txt"
    echo "Andra användare i systemet:" >> "$HOME_DIR/welcome.txt"

    cut -d: -f1 /etc/passwd | grep -v "^$user$" | sort >> "$HOME_DIR/welcome.txt"
done
