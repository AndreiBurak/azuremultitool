#!/bin/bash

# Define repository and file criteria
REPO="TheCloudTheory/arm-estimator"
ARCH="linux-x64"

# Fetch the latest release URL for the specified architecture
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/$REPO/releases/latest | grep "browser_download_url.*$ARCH" | cut -d '"' -f 4)

# Check if the download URL was found
if [ -z "$DOWNLOAD_URL" ]; then
	echo "No download URL found for $ARCH architecture."
	exit 1
fi

# Extract file name from URL
FILENAME=$(basename "$DOWNLOAD_URL")

# Download the zip file
echo "Downloading $FILENAME..."
# Check if wget is installed
if ! command -v wget &>/dev/null; then
	echo "wget could not be found. Please install wget and try again."
	exit 1
fi

if ! wget -q "$DOWNLOAD_URL" -O "$FILENAME"; then
	echo "Failed to download the file."
	exit 1
fi

echo "Download completed: $FILENAME"

# Extract the zip file
echo "Extracting $FILENAME..."
if ! unzip -q "$FILENAME" -d /usr/local/bin; then
	echo "Failed to extract the zip file."
	exit 1
fi
chmod +x /usr/local/bin/azure-cost-estimator
# Cleanup (optional)
rm "$FILENAME"
