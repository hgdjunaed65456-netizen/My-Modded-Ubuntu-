#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"

banner() {
	clear
	printf "${Y}  _  _  _   __  _  _  ___ ____     _  _  _  _ _  _ ____ ____ ___  \033[0m\n"
	printf "${C}  |__|  |  |    |_/  |___ |__/     |  |  |  | |\ | |__| |___ |  \ \033[0m\n"
	printf "${G}  |  |  |  |__  | \_ |___ |  \     |__|  |__| | \| |  | |___ |__/ \033[0m\n"
	printf "\033[0m\n"
	printf "     ${G}A modded gui version of ubuntu for Termux  ${C}by Junaed Ahmad\033[0m\n"
	printf "\033[0m\n"
}

install_sudo() {
	echo -e "\n${R} [${W}-${R}]${C} Installing Sudo...${W}"
	apt update -y
	apt install sudo -y
	apt install wget apt-utils locales-all dialog tzdata -y
	echo -e "\n${R} [${W}-${R}]${G} Sudo Successfully Installed !${W}"
}

login() {
	banner
	read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Username [Lowercase] : \e[0m\e[1;96m\e' user
	echo -e "${W}"

	# Fix: validate username not empty
	if [[ -z "$user" ]]; then
		echo -e "${R} [!] Username cannot be empty!${W}"
		exit 1
	fi

	read -s -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Password : \e[0m\e[1;96m\e' pass
	echo -e "${W}"

	# Fix: validate password not empty
	if [[ -z "$pass" ]]; then
		echo -e "${R} [!] Password cannot be empty!${W}"
		exit 1
	fi

	# Fix: check if user already exists before creating
	if id "$user" &>/dev/null; then
		echo -e "${Y} [!] User '$user' already exists, skipping creation.${W}"
	else
		useradd -m -s "$(which bash)" "${user}"
	fi

	usermod -aG sudo "${user}"
	echo "${user}:${pass}" | chpasswd

	# Fix: avoid duplicate sudoers entry
	grep -qxF "$user ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers || \
		echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

	# Fix: chmod uncommented — was commented out in original
	echo "proot-distro login --user $user ubuntu --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports" > /data/data/com.termux/files/usr/bin/ubuntu
	chmod +x /data/data/com.termux/files/usr/bin/ubuntu

	# Copy or download gui.sh
	if [[ -e '/data/data/com.termux/files/home/My-Modded-Ubuntu-/distro/gui.sh' ]]; then
		cp /data/data/com.termux/files/home/My-Modded-Ubuntu-/distro/gui.sh /home/$user/gui.sh
		chmod +x /home/$user/gui.sh
	else
		wget -q --show-progress \
			https://raw.githubusercontent.com/hgdjunaed65456-netizen/My-Modded-Ubuntu-/main/distro/gui.sh \
			-O /home/$user/gui.sh
		chmod +x /home/$user/gui.sh
	fi

	clear
	echo
	echo -e "\n${R} [${W}-${R}]${G} Restart your Termux & Type ${C}ubuntu${W}"
	echo -e "\n${R} [${W}-${R}]${G} Then Type ${C}sudo bash gui.sh${W}"
	echo
}

banner
install_sudo
login
