#!/bin/bash

# Exit if any command fails
set -e

echo "Starting Neovim Installation"

# Check for Homebrew installation
if command -v brew >/dev/null; then
    echo "Homebrew installed. Moving onto next step..."
else
    echo "Homebrew not installed. Please install Homebrew and try again."
    exit 1
fi

# Check for Neovim installation
if command -v nvim >/dev/null; then
    echo "Neovim installed. Moving onto next step..."
else
    echo "Neovim not installed/found. Installing via Homebrew..."
    brew install neovim
fi

# Check and handle Neovim configuration directory
config_dir="$HOME/.config/nvim"
if [ -d "$config_dir" ]; then
    echo "Neovim config directory already exists."

    while true; do
        read -rp "Do you wish to replace the existing config? (y/n): " answer
        case $(echo "$answer" | tr '[:upper:]' '[:lower:]') in
            y)
                echo "Removing existing Neovim config directory..."
                rm -rf "$config_dir"
                
                echo "Cloning Neovim config from GitHub..."
                git clone https://github.com/Mattwwilson34/test.git "$config_dir"
                break
                ;;
            n)
                echo "Exiting. No changes made."
                exit 0
                ;;
            *)
                echo "Invalid input. Please enter 'y' for yes or 'n' for no."
                ;;
        esac
    done
else
    echo "Cloning Neovim config from GitHub..."
    git clone https://github.com/Mattwwilson34/test.git "$config_dir"
fi

# Sync Packer plugins
echo "Syncing Packer plugins..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "Neovim installation and configuration complete."

