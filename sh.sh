#!/bin/bash

# Path to the repository directory
REPO_DIR="."

# Define the components
COMPONENT="main"

# Add packages to the repository
add_package() {
    package_file="$1"
    package_name="$2"
    package_version="$3"

    # Copy the package file to the repository's pool directory
    cp "$package_file" "$REPO_DIR/pool/$COMPONENT/"

    # Generate the package information file
    echo "Package: $package_name" >> "$REPO_DIR/dists/stable/$COMPONENT/binary-amd64/Packages"
    echo "Version: $package_version" >> "$REPO_DIR/dists/stable/$COMPONENT/binary-amd64/Packages"
    echo "Architecture: amd64" >> "$REPO_DIR/dists/stable/$COMPONENT/binary-amd64/Packages"
    echo "Filename: pool/$COMPONENT/$(basename "$package_file")" >> "$REPO_DIR/dists/stable/$COMPONENT/binary-amd64/Packages"
    echo "Size: $(stat -c%s "$package_file")" >> "$REPO_DIR/dists/stable/$COMPONENT/binary-amd64/Packages"
    echo "MD5sum: $(md5sum "$package_file" | awk '{print $1}') " >> "$REPO_DIR/dists/stable/$COMPONENT/binary-amd64/Packages"
    echo "SHA1: $(sha1sum "$package_file" | awk '{print $1}') " >> "$REPO_DIR/dists/stable/$COMPONENT/binary-amd64/Packages"
    echo "SHA256: $(sha256sum "$package_file" | awk '{print $1}') " >> "$REPO_DIR/dists/stable/$COMPONENT/binary-amd64/Packages"
    echo "" >> "$REPO_DIR/dists/stable/$COMPONENT/binary-amd64/Packages"

    # Add the package to the repository using reprepro
    reprepro -Vb "$REPO_DIR" includedeb stable "$package_file"
    
    # Print success message
    echo "Added package: $package_name ($package_version)"
}

# Add packages to the main component
add_package "./pool/minecraft.deb" "minecraft-launcher" "1.1.26"
add_package "./pool/sc-controller.deb" "sc-controller" "0.4.8.11"
