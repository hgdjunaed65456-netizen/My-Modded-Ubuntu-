#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"
arch=$(uname -m)
username=$(getent group sudo | awk -F ':' '{print $4}' | cut -d ',' -f1)

check_root(){
	if [ "$(id -u)" -ne 0 ]; then
		echo -ne " ${R}Run this program as root!\n\n${W}"
		exit 1
	fi
}

banner() {
	clear
	printf "
"
	printf "[1;31m _  _  _ ___  _  _ ____ ____ [0m
"
	printf "[1;31m |__| |/__|   |_/  |___ |__/ [0m
"
	printf "[1;31m |  | |\___ . |\_ .|___ |  \ [0m
"
	printf "
"
	printf "[1;33m ____  _  _ _  _ ____ ____ ____[0m
"
	printf "[1;33m   |   |  | |\| |__| |___ |  _[0m
"
	printf "[1;33m   |   |__| | \| |  | |___ |__][0m
"
	printf "
"
	printf "[1;36m Ubuntu Mod - by Junaed Ahmad[0m
"
	printf "[1;32m ============================[0m
"
	printf "
"
}  _  _  _   __  _  _  ___ ____     _  _  _  _ _  _ ____ ____ ___  
		${C}  |__|  |  |    |_/  |___ |__/     |  |  |  | |\ | |__| |___ |  \ 
		${G}  |  |  |  |__  | \_ |___ |  \     |__|  |__| | \| |  | |___ |__/ 

	EOF
	echo -e "${G}     A modded gui version of ubuntu for Termux  ${C}by Junaed Ahmad${W}\n"
}

note() {
	banner
	echo -e " ${G} [-] Successfully Installed !\n${W}"
	sleep 1
	cat <<- EOF
		 ${G}[-] Type ${C}vncstart${G} to run Vncserver.
		 ${G}[-] Type ${C}vncstop${G} to stop Vncserver.

		 ${C}Install VNC VIEWER Apk on your Device.

		 ${C}Open VNC VIEWER & Click on + Button.

		 ${C}Enter the Address localhost:1 & Name anything you like.

		 ${C}Set the Picture Quality to High for better Quality.

		 ${C}Click on Connect & Input the Password.

		 ${C}Enjoy :D${W}
	EOF
}

package() {
	banner
	echo -e "${R} [${W}-${R}]${C} Checking required packages...${W}"
	apt-get update -y
	apt install udisks2 -y
	rm -f /var/lib/dpkg/info/udisks2.postinst
	echo "" > /var/lib/dpkg/info/udisks2.postinst
	dpkg --configure -a
	apt-mark hold udisks2

	packs=(sudo gnupg2 curl wget nano git xz-utils at-spi2-core xfce4 xfce4-goodies xfce4-terminal librsvg2-common menu inetutils-tools dialog exo-utils tigervnc-standalone-server tigervnc-common tigervnc-tools dbus-x11 fonts-beng fonts-beng-extra gtk2-engines-murrine gtk2-engines-pixbuf apt-transport-https)
	for hulu in "${packs[@]}"; do
		dpkg -s "$hulu" &>/dev/null || {
			echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$hulu${W}"
			apt-get install "$hulu" -y --no-install-recommends
		}
	done

	apt-get update -y
	apt-get upgrade -y
}

install_apt() {
	for pkg in "$@"; do
		[[ $(command -v $pkg) ]] && echo "${Y}${pkg} is already Installed!${W}" || {
			echo -e "${G}Installing ${Y}${pkg}${W}"
			apt install -y "${pkg}"
		}
	done
}

install_vscode() {
	[[ $(command -v code) ]] && echo "${Y}VSCode is already Installed!${W}" || {
		echo -e "${G}Installing ${Y}VSCode${W}"
		curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
		install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
		echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
		apt update -y
		apt install code -y
		echo "Patching.."
		curl -fsSL https://raw.githubusercontent.com/hgdjunaed65456-netizen/My-Modded-Ubuntu-/main/patches/code.desktop > /usr/share/applications/code.desktop
		echo -e "${C} Visual Studio Code Installed Successfully\n${W}"
	}
}

install_sublime() {
	[[ $(command -v subl) ]] && echo "${Y}Sublime is already Installed!${W}" || {
		apt install gnupg2 software-properties-common wget --no-install-recommends -y

		# Fix: remove old broken source/key if exists
		rm -f /etc/apt/sources.list.d/sublime-text.list
		rm -f /etc/apt/trusted.gpg.d/sublime.gpg

		# Fix: use apt-key add — more reliable in proot environment
		wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
		echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list

		apt update -y
		apt install sublime-text -y
		echo -e "${C} Sublime Text Editor Installed Successfully\n${W}"
	}
}

install_chromium() {
	[[ $(command -v chromium-browser) ]] && echo "${Y}Chromium is already Installed!${W}" || {
		echo -e "${G}Installing ${Y}Chromium${W}"

		# Fix: no extra repo — just use Ubuntu's own chromium-browser package
		# Avoids dependency conflicts from mixing Debian + Ubuntu repos
		apt-get update -y
		apt-get install chromium-browser -y

		# Fix: no-sandbox for proot/root environment
		if [ -f /usr/share/applications/chromium-browser.desktop ]; then
			sed -i 's|Exec=chromium-browser|Exec=chromium-browser --no-sandbox|g' /usr/share/applications/chromium-browser.desktop
		fi
		if [ -f /usr/share/applications/chromium.desktop ]; then
			sed -i 's|Exec=chromium %U|Exec=chromium --no-sandbox %U|g' /usr/share/applications/chromium.desktop
		fi

		echo -e "${G} Chromium Installed Successfully\n${W}"
	}
}

install_firefox() {
	[[ $(command -v firefox) ]] && echo "${Y}Firefox is already Installed!${W}" || {
		echo -e "${G}Installing ${Y}Firefox${W}"

		# Fix: add DISPLAY export before installing so post-install hooks work
		export DISPLAY=:1

		bash <(curl -fsSL "https://raw.githubusercontent.com/hgdjunaed65456-netizen/My-Modded-Ubuntu-/main/distro/firefox.sh")

		# Fix: no-sandbox flag — required for proot/root environment
		for desktop_file in /usr/share/applications/firefox.desktop /usr/lib/firefox/firefox.desktop; do
			if [ -f "$desktop_file" ]; then
				sed -i 's|Exec=firefox %u|Exec=firefox --no-sandbox %u|g' "$desktop_file"
				sed -i 's|Exec=firefox %U|Exec=firefox --no-sandbox %U|g' "$desktop_file"
				sed -i 's|Exec=firefox$|Exec=firefox --no-sandbox|g' "$desktop_file"
			fi
		done

		echo -e "${G} Firefox Installed Successfully\n${W}"
	}
}

install_softwares() {
	banner
	cat <<- EOF
		${Y} ---${G} Select Browser ${Y}---

		${C} [${W}1${C}] Firefox (Default)
		${C} [${W}2${C}] Chromium
		${C} [${W}3${C}] Both (Firefox + Chromium)

	EOF
	read -n1 -p "${R} [${G}~${R}]${Y} Select an Option: ${G}" BROWSER_OPTION
	banner

	[[ ("$arch" != 'armhf') || ("$arch" != *'armv7'*) ]] && {
		cat <<- EOF
			${Y} ---${G} Select IDE ${Y}---

			${C} [${W}1${C}] Sublime Text Editor (Recommended)
			${C} [${W}2${C}] Visual Studio Code
			${C} [${W}3${C}] Both (Sublime + VSCode)
			${C} [${W}4${C}] Skip! (Default)

		EOF
		read -n1 -p "${R} [${G}~${R}]${Y} Select an Option: ${G}" IDE_OPTION
		banner
	}

	cat <<- EOF
		${Y} ---${G} Media Player ${Y}---

		${C} [${W}1${C}] MPV Media Player (Recommended)
		${C} [${W}2${C}] VLC Media Player
		${C} [${W}3${C}] Both (MPV + VLC)
		${C} [${W}4${C}] Skip! (Default)

	EOF
	read -n1 -p "${R} [${G}~${R}]${Y} Select an Option: ${G}" PLAYER_OPTION
	{ banner; sleep 1; }

	if [[ ${BROWSER_OPTION} == 2 ]]; then
		install_chromium
	elif [[ ${BROWSER_OPTION} == 3 ]]; then
		install_firefox
		install_chromium
	else
		install_firefox
	fi

	[[ ("$arch" != 'armhf') || ("$arch" != *'armv7'*) ]] && {
		if [[ ${IDE_OPTION} == 1 ]]; then
			install_sublime
		elif [[ ${IDE_OPTION} == 2 ]]; then
			install_vscode
		elif [[ ${IDE_OPTION} == 3 ]]; then
			install_sublime
			install_vscode
		else
			echo -e "${Y} [!] Skipping IDE Installation\n"
			sleep 1
		fi
	}

	if [[ ${PLAYER_OPTION} == 1 ]]; then
		install_apt "mpv"
	elif [[ ${PLAYER_OPTION} == 2 ]]; then
		install_apt "vlc"
	elif [[ ${PLAYER_OPTION} == 3 ]]; then
		install_apt "mpv" "vlc"
	else
		echo -e "${Y} [!] Skipping Media Player Installation\n"
		sleep 1
	fi
}

downloader(){
	path="$1"
	[[ -e "$path" ]] && rm -rf "$path"
	echo "Downloading $(basename $1)..."
	curl --progress-bar --insecure --fail \
		 --retry-connrefused --retry 3 --retry-delay 2 \
		  --location --output ${path} "$2"
}

sound_fix() {
	# Fix: prepend sound script only if not already there
	if ! grep -q 'bash ~/.sound' /data/data/com.termux/files/usr/bin/ubuntu; then
		echo "$(echo 'bash ~/.sound' | cat - /data/data/com.termux/files/usr/bin/ubuntu)" > /data/data/com.termux/files/usr/bin/ubuntu
	fi

	# Fix: correct DISPLAY — use single quotes to avoid quote parsing bug
	grep -qxF 'export DISPLAY=:1' /etc/profile || \
		echo 'export DISPLAY=:1' >> /etc/profile

	grep -qxF 'export PULSE_SERVER=127.0.0.1' /etc/profile || \
		echo 'export PULSE_SERVER=127.0.0.1' >> /etc/profile

	# Fix: also write to /etc/environment for GUI session
	grep -qxF 'DISPLAY=:1' /etc/environment || \
		echo 'DISPLAY=:1' >> /etc/environment
	grep -qxF 'PULSE_SERVER=127.0.0.1' /etc/environment || \
		echo 'PULSE_SERVER=127.0.0.1' >> /etc/environment
}

rem_theme() {
	theme=(Bright Daloa Emacs Moheli Retro Smoke)
	for rmi in "${theme[@]}"; do
		[ -d "/usr/share/themes/$rmi" ] && rm -rf "/usr/share/themes/$rmi"
	done
}

rem_icon() {
	icons=(hicolor LoginIcons ubuntu-mono-light)
	for rmf in "${icons[@]}"; do
		[ -d "/usr/share/icons/$rmf" ] && rm -rf "/usr/share/icons/$rmf"
	done
}

config() {
	banner
	sound_fix

	yes | apt upgrade
	yes | apt install gtk2-engines-murrine gtk2-engines-pixbuf sassc optipng inkscape libglib2.0-dev-bin
	[ -f /usr/share/backgrounds/xfce/xfce-verticals.png ] && \
		mv -vf /usr/share/backgrounds/xfce/xfce-verticals.png /usr/share/backgrounds/xfce/xfceverticals-old.png
	temp_folder=$(mktemp -d -p "$HOME")
	{ banner; sleep 1; cd "$temp_folder"; }

	echo -e "${R} [${W}-${R}]${C} Downloading Required Files..\n${W}"
	downloader "fonts.tar.gz"            "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/fonts.tar.gz"
	downloader "icons.tar.gz"            "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/icons.tar.gz"
	downloader "wallpaper.tar.gz"        "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/wallpaper.tar.gz"
	downloader "gtk-themes.tar.gz"       "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/gtk-themes.tar.gz"
	downloader "ubuntu-settings.tar.gz"  "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/ubuntu-settings.tar.gz"

	echo -e "${R} [${W}-${R}]${C} Unpacking Files..\n${W}"
	tar -xzf fonts.tar.gz           -C "/usr/local/share/fonts/"
	tar -xzf icons.tar.gz           -C "/usr/share/icons/"
	tar -xzf wallpaper.tar.gz       -C "/usr/share/backgrounds/xfce/"
	tar -xzf gtk-themes.tar.gz      -C "/usr/share/themes/"
	tar -xzf ubuntu-settings.tar.gz -C "/home/$username/"
	rm -fr "$temp_folder"

	echo -e "${R} [${W}-${R}]${C} Purging Unnecessary Files..${W}"
	rem_theme
	rem_icon

	echo -e "${R} [${W}-${R}]${C} Rebuilding Font Cache..\n${W}"
	fc-cache -fv

	echo -e "${R} [${W}-${R}]${C} Upgrading the System..\n${W}"
	apt update
	yes | apt upgrade
	apt clean
	yes | apt autoremove
}

# ----------------------------

check_root
package
install_softwares
config
note
