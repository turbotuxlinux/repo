#!/bin/bash

# Define variables
REPO_PATH="."
ARCHITECTURES="amd64 i386"
PACKAGE_FILES="$REPO_PATH/pool/main/*.deb"
GPG_KEY_ID="58D58E9BAF1128CAB6CF895ACFE7731D7F28095A"

# Create the repository directory structure
mkdir -p $REPO_PATH/pool/main
mkdir -p $REPO_PATH/dists/stable/main/binary-amd64
mkdir -p $REPO_PATH/dists/stable/main/binary-i386

# Move package files to the pool directory
mv $PACKAGE_FILES $REPO_PATH/pool/main/

# Generate 'Packages' and 'Packages.gz' for both architectures
dpkg-scanpackages $REPO_PATH/pool/main /dev/null | gzip -9c > $REPO_PATH/dists/stable/main/binary-amd64/Packages.gz
dpkg-scanpackages $REPO_PATH/pool/main /dev/null | gzip -9c > $REPO_PATH/dists/stable/main/binary-i386/Packages.gz

# Create an empty 'Packages' file for both architectures
touch $REPO_PATH/dists/stable/main/binary-amd64/Packages
touch $REPO_PATH/dists/stable/main/binary-i386/Packages

# Generate 'Release' file
apt-ftparchive release $REPO_PATH/dists/stable/main/binary-amd64 > $REPO_PATH/dists/stable/Release

# Sign 'Release' file with GPG key
gpg --default-key $GPG_KEY_ID -abs -o $REPO_PATH/dists/stable/Release.gpg $REPO_PATH/dists/stable/Release

# Copy 'Release' and 'InRelease' files to each architecture-specific folder
for ARCH in $ARCHITECTURES; do
    cp $REPO_PATH/dists/stable/Release $REPO_PATH/dists/stable/main/binary-$ARCH/
    cp $REPO_PATH/dists/stable/Release.gpg $REPO_PATH/dists/stable/main/binary-$ARCH/InRelease
done

