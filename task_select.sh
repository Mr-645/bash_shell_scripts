#!/bin/bash
# This script is for running pre-made bash commands
version=0.0.5

# This is how you execute this script remotely: ssh user@remote_server "$(< localfile)"
# Replace "localfile" with "Documents/task_select.sh"

# https://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script#1716
# https://unix.stackexchange.com/questions/293604/bash-how-to-make-each-menu-selections-in-1-line-instead-of-multiple-selections
# https://stackoverflow.com/questions/35769054/bash-mint-how-to-add-a-newline-to-a-ps3-prompt

# TERMINAL TEXT COLOUR help
# http://www.linuxcommand.org/lc3_adv_tput.php
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux

COLUMNS=30
PS3=$'\n'"Please enter the number corresponding to the operation of your choice: "
options=("Find file" "Computer/Kernel info" "Devices" "Disc info" "un/Mount a device" "Apt update/upgrade" "Task manager" "Ports" "ip address" "Search apt repositories for a package" "Search for an installed package" "Find SOURCE FILES for an installed package" "list of installed packages" "Services" "Suspend" "Quit")

if  [[ $1 = "--help" ]]; then
    printf "This script is for running pre-made bash commands\n"
	printf "$(tput rev)Usage: ./task_select [Options]$(tput sgr0)\n\n"
	printf "Options:\n"
	printf " -v\tprint version number and 'about' info\n"
elif [[ $1 = "-v" ]]; then
	printf "Script name: Task select\nAuthor: https://github.com/Mr-645/ \nVersion number: ${version}\n"
else
	printf "$Suffix command with '--help' for more info"
	printf "\n$(tput smso)Select an operation from the list below$(tput sgr0)\n\n"
	select opt in "${options[@]}"
	do
		case $opt in
			"Find file")
				printf "\n ==== Find file function ====\n"
				printf "Search whole disc: [w]\nSearch current dir and beneath: [c]\n... "
				read search_param
				printf "File name contains following string... "
				read name_string
				printf "File extension (e.g. [txt])... "
				read file_ext
				main_string="find"
				
				if [ "$search_param" = "w" ]; then
					main_string="sudo ${main_string} / -name '*${name_string}*.${file_ext}'"
				elif [ "$search_param" = "c" ]; then
					main_string="${main_string} . -name '*${name_string}*.${file_ext}'"
				else
					printf "\nSomething went wrong"
					printf "\n   search_param = ${search_param}"
					printf "\n   name_string = ${name_string}"
					printf "\n   file_ext = ${file_ext}"
					printf "\n   main_string = ${main_string}\n"
				fi
				
				printf "\n================ Output START ================\n"
				eval $main_string
				printf "================ Output END ================\n"
				printf "\n---Command was->        ${main_string}"
				
				printf "\nOperation '$REPLY: $opt' is complete\n"
				break
				;;
			"Computer/Kernel info")
				printf "\nSystem and kernel info [s]? \nOr print kernel ring buffer [r]? \nOr Search keyword/string in ring buffer [k]... "
				read kernel_choice
				printf "\n"
				
				if [ "$kernel_choice" = "s" ]; then
					uname -a
				elif [ "$kernel_choice" = "r" ]; then
					dmesg
				elif [ "$kernel_choice" = "k" ]; then
					printf "Enter keyword/string... \n"
					read ker_sea_str
					printf "\n\n"
					dmesg | grep $ker_sea_str
				else
					printf "Something went wrong"
					printf "\n   kernel_choice = ${kernel_choice}\n"
				fi
				
				printf "\nOperation '$REPLY: $opt' is complete\n"
				break
				;;
			"Devices")
				printf "\nList USB devices [u]? Or list block devices [b]?... "
				read device_choice
				printf "\n"
				
				if [ "$device_choice" = "u" ]; then
					lsusb
				elif [ "$device_choice" = "b" ]; then
					lsblk
				else
					printf "Something went wrong"
					printf "\n   device_choice = ${device_choice}\n"
				fi
				
				printf "\nOperation '$REPLY: $opt' is complete\n"
				break
				;;
			"Disc info")
				printf "\nSimple disc info [s]? Or extensive disc info [e]?... "
				read disc_comp_choice
				printf "\n"
				
				if [ "$disc_comp_choice" = "s" ]; then
					df -ah
				elif [ "$disc_comp_choice" = "e" ]; then
					sudo fdisk -l
				else
					printf "Something went wrong"
					printf "\n   disc_comp_choice = ${disc_comp_choice}\n"
				fi
				
				printf "\nOperation '$REPLY: $opt' is complete\n"
				break
				;;
			"un/Mount a device")	
				printf "\n$(tput setaf 6)$(tput smul)Here are the connected devices$(tput sgr0)\n\n"
				#tput setaf 7; tput setab 1
				tput setaf 3; tput rev
				sudo blkid
				printf "\n"
				sudo lsblk
				tput sgr0
				
				printf "\nMount [m], un-mount [u], or cancel [c]?... "
				tput setaf 2; read mount_choice; tput sgr0
					
				if [ "$mount_choice" = "m" ]; then
					printf "\n\nType in the path of the device you want to mount: "
					tput setaf 2; read device_path; tput sgr0
					printf "\nType in the path of the directory you want to mount it to: "
					tput setaf 2; read mount_path; tput sgr0
					sudo mount $device_path $mount_path
					printf "\nThe command was: sudo mount ${device_path} ${mount_path}\n"
					tput setaf 3; tput rev; sudo lsblk; tput sgr0
				elif [ "$mount_choice" = "u" ]; then
					printf "\n\nType in the path of the device you want to dismount: "
					tput setaf 2; read device_path; tput sgr0
					sudo umount $device_path
					printf "\nThe command was: sudo umount ${device_path}\n"
					tput setaf 3; tput rev; sudo lsblk; tput sgr0
				elif [ "$mount_choice" = "c" ]; then
					tput sgr0
				else
					printf "Something went wrong"
					printf "\n   mount_choice = ${mount_choice}\n"
				fi
				
				printf "\nOperation '$REPLY: $opt' is complete\n"
				break
				;;
			"Apt update/upgrade")
				printf "\nJust update repositories [d]? Or update, and upgrade system pakcages [g]?... "
				read update_choice
				printf "\n"
				
				if [ "$update_choice" = "d" ]; then
					sudo apt update
				elif [ "$update_choice" = "g" ]; then
					sudo apt update && sudo apt upgrade
				else
					printf "Something went wrong"
					printf "\n   update_choice = ${update_choice}\n"
				fi
				
				printf "\nOperation '$REPLY: $opt' is complete\n"
				break
				;;
			"Task manager")
				printf "\n"
				htop
				printf "\nOperation '$REPLY: $opt' is complete\n"
				break
				;;
			"Ports")
				printf "\n"
				sudo netstat -tulpn
				printf "\nOperation '$REPLY: $opt' is complete\n"
				break
				;;
			"ip address")
				printf "\n"
				ip addr
				printf "\nOperation '$REPLY: $opt' is complete\n"
				break
				;;
			"Search apt repositories for a package")
				printf "\n"
				printf "Enter name of package in repositories... \n"
				read pak_name
				apt search $pak_name
				printf "\nOperation '$REPLY: $opt' is complete\n"
				break
				;;
			"Search for an installed package")
				printf "\n"
				printf "Enter installed package name... \n"
				read pak_name
				dpkg -s $pak_name
				
				printf "\nGo to its launcher location? [y] or [n]... "
				read gtd
				
				if [ "$gtd" = "y" ]; then
					pak_dir="$(which ${pak_name})"
					printf "\nThe executable location is: " $pak_dir"\n"
					cd $pak_dir
				elif [ "$gtd" = "n" ]; then
					printf "\nOperation '$REPLY: $opt' is complete\n"
				else
					printf "Something went wrong"
					printf "\n   gtd = ${gtd}\n"
				fi
				
				break
				;;
			"Find SOURCE FILES for an installed package")
				printf "\n"
				printf "Enter installed package name... \n"
				read pak_name
				printf "\n ________LIST START________ \n\n"
				dpkg --list $pak_name
				printf "\n ________LIST END________ \n\n"
				printf "\n ________LIST FILES START________ \n\n"
				dpkg --listfiles $pak_name
				printf "\n ________LIST FILES END________ \n"
				printf "\nOperation '$REPLY: $opt' is complete\n"
				break
				;;
			"list of installed packages")
				printf "\nSimple package info [s]? Or extensive package info [e]?... "
				read package_comp_choice
				printf "\n"
				
				if [ "$package_comp_choice" = "s" ]; then
					apt list --installed
				elif [ "$package_comp_choice" = "e" ]; then
					dpkg -l
				else
					printf "Something went wrong"
					printf "\n   package_comp_choice = ${package_comp_choice}\n"
				fi
				
				printf "\nOperation '$REPLY: $opt' is complete\n"
				break
				;;
			"Services")
				printf "\nList all services [a]?\nList only, loaded and active services[c]\nLook for any service by keyword/string [l]\nLook for loaded and active service by keyword/string [s]?... "
				read service_choice
				printf "\n"
				
				if [ "$service_choice" = "a" ]; then
					systemctl list-units --type=service -all
				elif [ "$service_choice" = "c" ]; then
					systemctl list-units --type=service
				elif [ "$service_choice" = "l" ]; then
					printf "Enter keyword/string corresponding to service... \n"
					read ser_name
					systemctl list-units --type=service -all | grep $ser_name
				elif [ "$service_choice" = "s" ]; then
					printf "Enter keyword/string corresponding to service... \n"
					read ser_name
					systemctl list-units --type=service | grep $ser_name
				else
					printf "Something went wrong"
					printf "\n   service_choice = ${service_choice}\n"
				fi
				
				printf "\nOperation '$REPLY: $opt' is complete\n"
				break
				;;
			"Suspend")
				printf "\nGoing to sleep now\n"
				sudo systemctl suspend
				break
				;;
			"Quit")
				break
				;;
			*) echo "invalid option $REPLY";;
		esac
	done
fi
