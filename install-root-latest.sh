#!/bin/bash

# Download the ROOT releases page and match the recent ROOT version
# https://stackoverflow.com/questions/1891797/capturing-groups-from-a-grep-regex

string=`wget https://root.cern/install/all_releases/ -q -O -`
regex="[0-9]+\.[0-9]+\/[0-9]+"

if [[ $string =~ $regex ]] 
then
	# Get ROOT version from the match group
	v="${BASH_REMATCH[0]}"
	
	# Replace / with . in version number
	v=`echo "$v" | sed 's/\//\./'`
	echo "$v"

	# Update the system
	sudo apt-get update && sudo apt-get -y upgrade	

	# Install ROOT dependencies
	sudo apt -y install build-essential
	sudo apt -y install git dpkg-dev cmake g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev python libssl-dev
	sudo apt -y install gfortran libpcre3-dev xlibmesa-glu-dev libglew1.5-dev libftgl-dev libmysqlclient-dev libfftw3-dev libcfitsio-dev graphviz-dev libavahi-compat-libdnssd-dev libldap2-dev python-dev libxml2-dev libkrb5-dev libgsl0-dev

	# Download ROOT (-O overwrite existing file)
	cd ~/Downloads
	wget -O root_v$v.source.tar.gz https://root.cern/download/root_v$v.source.tar.gz

	# Unpack ROOT archive
	mkdir -p ~/Source && cd ~/Source
	tar -xvf ~/Downloads/root_v$v.source.tar.gz

	# Create install and build directories
	rm -rf ~/Applications/root-$v && mkdir -p ~/Applications/root-$v
	rm -rf ~/Source/root-$v-build && mkdir -p ~/Source/root-$v-build && cd ~/Source/root-$v-build

	# Unset environment libraries (if previously installed ROOT)
	# https://root-forum.cern.ch/t/cannot-compile-root-v6-22-08-with-debug-symbols-and-all-options/44242
	unset ROOTSYS
	unset LD_LIBRARY_PATH

	# Compile ROOT
	cmake -Dall=ON -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=~/Applications/root-$v ~/Source/root-$v
	cmake --build . --target install -- -j$(nproc)

	# Source ROOT
	cd ~/Applications/root-$v
	sed -i "/#source-thisroot/d" ~/.bashrc
	echo source `find $(pwd) -name "thisroot.sh" #source-thisroot` >> ~/.bashrc
	source ~/.bashrc	
	
	# Install ROOT icon
	wget https://raw.githubusercontent.com/petrstepanov/gnome-third-party-icons/65f9731a4260b499b7a86e9968dbc05a3a5066a6/icons/gnome-cernroot.svg
	cp ./gnome-cernroot.svg ~/.local/share/icons/hicolor/scalable/apps/
	gtk-update-icon-cache
	
	# Create desktop launcher for .root files
	launcher="$HOME/.local/share/applications/rootbrowse.desktop"
	echo "[Desktop Entry]" > $launcher
	echo "Type=Application" >> $launcher
	echo "Name=ROOT Browser" >> $launcher
	echo "Comment=Open CERN ROOT files" >> $launcher
	echo "Icon=gnome-cernroot" >> $launcher
	echo "Exec=rootbrowse %F" >> $launcher
	echo "Terminal=true" >> $launcher
	echo "Categories=Science" >> $launcher
else
	echo Cannot determine the recent ROOT version
fi
