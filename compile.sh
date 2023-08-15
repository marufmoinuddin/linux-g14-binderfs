#!/bin/bash

# Create a temporary directory to hold package output
mkdir -p package_output

# Install required dependencies
sudo pacman -Sy --noconfirm base-devel devtools wget git --overwrite '*'

# Clone the repository
git clone https://aur.archlinux.org/linux-g14.git

# Install extra dependencies needed for building the kernel
makedepends=$(awk '/^makedepends=\(/,/\)/ {gsub(/[\(\)]/,""); gsub(/^makedepends= /, ""); print}' linux-g14/PKGBUILD | tr -d '\n' | sed 's/#.*//; s/  */ /g' | sed 's/makedepends=//')
sudo pacman -Sy --noconfirm $makedepends --needed --overwrite '*'

# Build the package using makepkg
cp add-lines.sh linux-g14/add-lines.sh
chmod +x linux-g14/add-lines.sh
cd linux-g14
sh add-lines.sh
makepkg -s --noconfirm --skippgpcheck

# Move the generated package files 
mv *.pkg.tar.zst ../package_output/

