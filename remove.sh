#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
C="$(printf '\033[1;36m')"
W="$(printf '\033[1;37m')"

banner() {
	clear
	printf "\n"
	printf "\033[1;31m +--------------------------+\033[0m\n"
	printf "\033[1;31m |   HACKER   JUNAED        |\033[0m\n"
	printf "\033[1;31m +--------------------------+\033[0m\n"
	printf "\033[1;36m  Ubuntu Mod by Junaed Ahmad\033[0m\n"
	printf "\033[1;32m +--------------------------+\033[0m\n"
	printf "\n"
}

remove() {
	banner
	echo -e "${R} [${W}-${R}]${C} Are you sure you want to remove Ubuntu? (y/n): ${W}"
	read -n1 CONFIRM
	echo

	if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
		echo -e "\n${Y} [!] Removal cancelled.${W}"
		exit 0
	fi

	echo -e "\n${R} [${W}-${R}]${C} Removing Ubuntu distro...${W}"

	if command -v proot-distro &>/dev/null; then
		proot-distro remove ubuntu && proot-distro clear-cache
	else
		echo -e "${Y} [!] proot-distro not found, skipping.${W}"
	fi

	[ -f "$PREFIX/bin/ubuntu" ] && rm -f "$PREFIX/bin/ubuntu"

	if [ -f "$HOME/.sound" ]; then
		sed -i '/pacmd load-module module-aaudio-sink/d' "$HOME/.sound"
		sed -i '/pulseaudio --start --exit-idle-time=-1/d' "$HOME/.sound"
		sed -i '/pacmd load-module module-native-protocol-tcp/d' "$HOME/.sound"
	fi

	echo -e "\n${G} [+] Ubuntu removed successfully!${W}\n"
}

banner
remove
