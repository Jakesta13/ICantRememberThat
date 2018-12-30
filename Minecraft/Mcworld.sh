#!/bin/bash
### ### ### Settings ### ### ###
# This script is to make downloading a backup of a minecraft world a LOT simpler.
# It could probably be simplified, or made better, but the main part of this is that it works ... or so it should.
# I created this so if you do not have enough space to compress the world file on the host machine, you
# can download it locally, as a compressed tarball.


# “Enter sudo password” came from
# https://askubuntu.com/a/1048674

# YOU NEED TO CREATE AN SSH PUBLIC/PRIVATE KEY FOR THE REMOTE SERVER

# Use IFTTT to notify?
IFTTT=n
IFTTT_KEY=???
IFTTT_APPLET=???

# Drive to mount?
drive=/dev/sda2

# Place to mount to?
mount=/path/to/folder/

# User to assign to?
usr=???

# Group to assign to?
grp=???

# Retreval settings
IP=????
# User to login
USER=????
# Identiy file
ID=/path/to/public/id_file.rsa
# Remote DIR
# Note: Do not place the location OF the world directory, instead place the directory where the world folder can be found AT.
RDIR=/path/to/minecraft/server/base/dir

# We will ask for the world and output file later.


# Colour setup
# https://stackoverflow.com/a/20983251
yellow=$(tput setaf 3)
red=$(tput setaf 1)
creset=$(tput sgr0)


# http://github.com/jakesta13
### ### ### ### ### ###

echo “${yellow}”
echo “Reminder; Check the script file for detailed config”
read -n 1 -s -r -p “Press any key to continue”
echo “”
echo “${creset}”


# We need the sudo password, so this makes it more stream-lined.
# If you are uncomfortable entering the password, type “no”
echo “${red}”
echo “Please enter sudo password.”
sleep 0.5
echo “We need this for mounting and unmounting,”
sleep 0.5
echo “if you are uncomfortable entering the password here, type ‘no’”
sleep 0.5
echo “sudo will ask for a password when needed instead.”
echo “${creset}”
sleep 1
read sudo
sleep 1
echo “Thanks!”
sleep 2
clear

# Asking for user input for world and output file
# http://www.tldp.org/LDP/Bash-Beginners-Guide/html/sect_08_02.html
echo “What is the world name you want to backup?”
echo “Only enter the world name.”
read World
sleep 1
echo “Good, you have entered ${World}”
echo “If this is incorrect, please Ctrl + c and start over.”
echo “Now, enter the output name”
echo “Do not enter file extentions, we do that already.”
read output
sleep 1
echo “Awesome, you have entered ${output}”
echo “If this is incorrect, please Ctrl + c and start over.”
echo “Please press any key to contine once you have veriried everything is correct.”
echo “${yellow}”
echo “World: ${World}”
echo “Output filename: ${output}.tar.gz”
echo “Remote directory: ${RDIR}”
echo “Output directory: ${mount}”
echo “Server: ${IP}”
echo “ID file: ${ID}”
echo “${creset}”
# https://unix.stackexchange.com/a/293941
read -n 1 -s -r -p “Press any key to continue”
echo “”

# lets check if the mount folder exists first
if [ -d “${mount}” ]; then
	echo “Mounting point, ${mount}, exists”
	sleep 1
else
	echo “Creating mounting point”
	mkdir “${mount}”
	sleep 1
	echo “Checking if it exists now.. if it fails, we will exit.”
	sleep 1
		if [ -d “${mount}” ]; then
			echo “Mount point was made sucessfully”
		else
			exit
		fi
fi

# It’s bad to use sudo normally, but it is required here... unless theres another solution unheard of.

if [ “${sudo}” == “no” ]; then
	sudo mount -t ntfs -o uid=${usr},gid=${grp} “${drive}” “${mount}”
else
	# Enter password part
	echo “${sudo}” | sudo mount -t ntfs -o uid=${usr},gid=${grp} “${drive}” “${mount}”
fi

ssh ${USER}@${IP} -i ~/.ssh/id_rsa “cd ${RDIR} && tar -zcf - ${World}/ “ > ${mount}/${output}.tar.gz

if [ -e ${mount}/${output} ]; then
	fail=0
	echo “Coppied correctly”
	echo “Making Md5sum”
	md5sum “${mount}/${output}.tar.gz” > “${output}.md5"
	cat “${mount}/${output}.md5”
else
	echo “Failure to find coppied file, please try again unfortunately.”
	fail=1
fi
if [ “${fail}” == “1” ]; then
	if [ “${IFTTT}” == “y” ]; then
		curl -X POST —data “value1=FAILED&value2=FAILED” “https://maker.ifttt.com/trigger/${IFTTT_APPLET}/with/key/${IFTTT_KEY}”
	fi
else
	if [ “${IFTTT}” == “y” ]; then
		curl -X POST —data “value1=${World}&value2=${output}” “https://maker.ifttt.com/trigger/${IFTTT_APPLET}/with/key/${IFTTT_KEY}”
	fi
fi

echo “Do you wish to unmount the drive?”
echo “Enter only y/n, any other answer will be considered as n”
read umount
if [ “${umount}” == “y” ]; then
# I know sudo is bad to use
	if [ “${sudo}” == “no” ]; then
		sudo umount “${mount}”
	else
		# Enter password part
		echo “${sudo}” | sudo umount “${mount}”
	fi
else
	echo “Not unmounting”
fi
echo “Done, Pausing for output review...”
read -n 1 -s -r -p “Press any key to continue”
exit
