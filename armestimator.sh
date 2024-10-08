#!/bin/bash

# Define repository and file criteria
REPO="TheCloudTheory/arm-estimator"
ARCH="linux-64"

# Fetch the latest release URL for the specified architecture
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/$REPO/releases/latest | grep "browser_download_url.*$ARCH" | cut -d '"' -f 4)

# Check if the download URL was found
if [ -z "$DOWNLOAD_URL" ]; then
    echo "No download URL found for $ARCH architecture."
    exit 1
fi

# Extract file name from URL
FILENAME=$(basename "$DOWNLOAD_URL")

# Download the .deb file
echo "Downloading $FILENAME..."
wget -q "$DOWNLOAD_URL" -O "$FILENAME"

# Check if download was successful
if [ $? -ne 0 ]; then
    echo "Failed to download the file."
    exit 1
fi

echo "Download completed: $FILENAME"

# Install the .deb file using dpkg
echo "Installing $FILENAME..."
dpkg -i "$FILENAME"

# Check if installation was successful
if [ $? -ne 0 ]; then
    echo "Failed to install the .deb package."
    exit 1
fi

echo "Installation complete!"

# Cleanup (optional)
# rm "$FILENAME"

