#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
B="$(printf '\033[1;34m')"
C="$(printf '\033[1;36m')"
W="$(printf '\033[1;37m')"

banner() {
	clear
	printf "${Y}  _  _  _   __  _  _  ___ ____     _  _  _  _ _  _ ____ ____ ___  \033[0m\n"
	printf "${C}  |__|  |  |    |_/  |___ |__/     |  |  |  | |\ | |__| |___ |  \ \033[0m\n"
	printf "${G}  |  |  |  |__  | \_ |___ |  \     |__|  |__| | \| |  | |___ |__/ \033[0m\n"
	printf "\033[0m\n"
	printf "     ${G}A modded gui version of ubuntu for Termux  ${C}by Junaed Ahmad\033[0m\n"
	printf "\033[0m\n"
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

	# Fix: check if proot-distro exists before running
	if command -v proot-distro &>/dev/null; then
		proot-distro remove ubuntu && proot-distro clear-cache
	else
		echo -e "${Y} [!] proot-distro not found, skipping distro removal.${W}"
	fi

	# Fix: check if ubuntu bin exists before removing
	[ -f "$PREFIX/bin/ubuntu" ] && rm -f "$PREFIX/bin/ubuntu"

	# Fix: only remove sound entries if they exist
	if [ -f "$HOME/.sound" ]; then
		sed -i '/pacmd load-module module-aaudio-sink/d' "$HOME/.sound"
		sed -i '/pulseaudio --start --exit-idle-time=-1/d' "$HOME/.sound"
		sed -i '/pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1/d' "$HOME/.sound"
		echo -e "${G} [+] Sound config cleaned.${W}"
	fi

	# Fix: also clean DISPLAY and PULSE_SERVER from profile if set
	if [ -f "$HOME/.profile" ]; then
		sed -i '/export DISPLAY=:1/d' "$HOME/.profile"
		sed -i '/export PULSE_SERVER=127.0.0.1/d' "$HOME/.profile"
	fi

	echo -e "\n${G} [+] Ubuntu removed successfully!${W}\n"
}

banner
remove
