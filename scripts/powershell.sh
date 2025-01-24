#!/bin/bash

set -e  # Exit on error

# Create temp directory for downloads
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Source Ubuntu version information
if ! source /etc/os-release; then
    echo "Failed to get Ubuntu version"
    exit 1
fi

# Download and install Microsoft repository keys
MS_REPO_KEY="$TEMP_DIR/packages-microsoft-prod.deb"
if ! wget -q "https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb" -O "$MS_REPO_KEY"; then
    echo "Failed to download Microsoft repository keys"
    exit 1
fi

# Install the package
if ! dpkg -i "$MS_REPO_KEY"; then
    echo "Failed to install Microsoft repository keys"
    exit 1
fi

# Update package list
if ! apt-get update; then
    echo "Failed to update package list"
    exit 1
fi

# Install PowerShell
if ! apt-get install -y powershell; then
    echo "Failed to install PowerShell"
    exit 1
fi

echo "PowerShell installation completed successfully"