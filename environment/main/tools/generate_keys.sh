#!/bin/bash

# Define key parameters
KEY_NAME="pandora"
KEY_EMAIL="pandora@pandora.pandora"
KEY_COMMENT="for the box"

# Generate the GPG key pair
echo -e "Generating GPG key pair...\n"
gpg --batch --gen-key <<EOF
    Key-Type: rsa
    Key-Length: 4096
    Subkey-Type: default
    Subkey-Length: 4096
    Name-Real: $KEY_NAME
    Name-Email: $KEY_EMAIL
    Name-Comment: $KEY_COMMENT
    Expire-Date: 0
    %no-protection
EOF

# List keys to verify creation
echo -e "\nListing GPG keys:\n"
gpg --list-keys

echo -e "\nGPG key pair generated successfully."
