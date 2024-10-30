#!/usr/bin/env bash
set -e

# Activate the virtual environment
source /opt/ansible-venv/bin/activate

# check if SSH key exists in user home folder
# and if not check if it exists in the mounted workdir's files directory
if [ ! -f ~/.ssh/id* ]; then
    if  ls files/keys/id* >/dev/null 2>&1; then
        cp files/keys/id* ~/.ssh/
        chmod 600 ~/.ssh/id*
        chmod 644 ~/.ssh/id*.pub
    else
        echo "WARNING: SSH key cannot be found!"
        echo ""
    fi
fi

exec "$@"
