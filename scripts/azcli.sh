#!/bin/bash

set -e # Exit on error

# Function to install prerequisites
install_prereqs() {
	echo "Setting up prerequisites..."
	if ! mkdir -p /etc/apt/keyrings; then
		echo "Failed to create keyrings directory"
		exit 1
	fi
}

# Function to setup Microsoft GPG key
setup_gpg_key() {
	echo "Installing Microsoft GPG key..."
	if ! curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
		gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg >/dev/null; then
		echo "Failed to download and install GPG key"
		exit 1
	fi

	if ! chmod go+r /etc/apt/keyrings/microsoft.gpg; then
		echo "Failed to set GPG key permissions"
		exit 1
	fi
}

# Function to setup repository
setup_repository() {
	echo "Setting up Azure CLI repository..."
	AZ_DIST=$(lsb_release -cs)

	if [ -z "$AZ_DIST" ]; then
		echo "Failed to determine distribution"
		exit 1
	fi

	echo "Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg" | tee /etc/apt/sources.list.d/azure-cli.sources
}

# Function to install Azure CLI
install_azure_cli() {
	echo "Installing Azure CLI..."
	if ! apt-get update; then
		echo "Failed to update package list"
		exit 1
	fi

	if ! apt-get install -y azure-cli; then
		echo "Failed to install Azure CLI"
		exit 1
	fi
}

# Main installation process
main() {
	install_prereqs
	setup_gpg_key
	setup_repository
	install_azure_cli
	az self-test
	az --version
	echo "Azure CLI installation completed successfully"
}

# Run main function
main
