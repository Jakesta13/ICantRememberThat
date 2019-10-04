#!/bin/bash
### ### ### Settings ### ### ###
# Would you like to keep the downloaded java install file?
# Vaid options: y/n
keep=n

# Download location:
dir=.

# https://jakesta13.github.com
### ### ### ### ### ###
echo "This script is currently unable to check if you have java already installed, this must be manually verified."
echo "If you know that you have java installed, please enter n ... otherwise enter y."
echo "If you do not know if you have java installed, please ctrl + c this script and run 'Java -version' and if it comes up as invalid then you do not have java"
echo ""
# Read pause from: https://askubuntu.com/a/446161
read  -n 1 -p "Input Selection:" installagree
echo ""
if [ ${installagree} == "n" ] ; then
	echo "Java is already installed"
else
	echo "Making Directory and downloading the tar"
	mkdir "${dir}/dl-jar"
	(cd "${dir}/dl-jar/" && wget https://github.com/frekele/oracle-java/releases/download/8u212-b10/jdk-8u212-linux-arm32-vfp-hflt.tar.gz)
	echo "Installing ...."
	if [ -f "${dir}/dl-jar/jdk-8u212-linux-arm32-vfp-hflt.tar.gz" ] ; then
		echo "If you change your mind you can Ctrl+C in 10s"
		# Code below found at https://serverfault.com/a/532564
		secs=$((10))
		while [ $secs -gt 0 ]; do
	   		echo -ne "$secs\033[0K\r"
	   		sleep 1
	  		 : $((secs--))
		done
		### ### ###
	# I know sudo is not a good choice to use here, but this is made to be ran on Raspberry Pis, and sudo usually doesn't need passwords
		sudo mkdir /usr/java
		(cd /usr/jar/ && sudo tar xf ${dir}/dl-jar/jdk-8u212-linux-arm32-vfp-hflt.tar.gz)
		sudo update-alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_212/bin/java 1000
		sudo update-alternatives --install /usr/bin/javac javac /usr/java/jdk1.8.0_212/bin/javac 1000
		if [ ${keep} == "y" ] ; then
			echo "Downloaded file is in ${dir}/dl-jar"
		else
			rm -rf ${dir}/dl-jar/
			echo "Downloaded file was deleted"
		fi
	fi
	fi
