#!/bin/bash

# Fix: remove snap firefox if exists
[[ $(command -v snap) ]] && snap remove firefox 2>/dev/null

PREFFILE="/etc/apt/preferences.d/mozilla-firefox"

print_key() {
    cat <<-EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----
Comment: Hostname: 
Version: Hockeypuck 2.1.0-189-g15ebf24

xo0ESXMwOwEEAL7UP143coSax/7/8UdgD+WjIoIxzqhkTeoGOyw/r2DlRCBPFAOH
lsUIG3AZrHcPVzA3bRTGoEYlrQ9d0+FsUI57ozHdmlsaekEJpQ2x7wZL7c1GiRqC
A4ERrC6kNJ5ruSUHhB+8qiksLWsTyjM7OjIdkmDbH/dYKdFUEKTdljKHABEBAAHN
HkxhdW5jaHBhZCBQUEEgZm9yIE1vemlsbGEgVGVhbcK2BBMBAgAgBQJJczA7AhsD
BgsJCAcDAgQVAggDBBYCAwECHgECF4AACgkQm9s9ic5J7CGfEgP/fcx3/CSAyyWL
lnL0qjjHmfpPd8MUOKB6u4HBcBNZI2q2CnuZCBNUrMUj67IzPg2llmfXC9WxuS2c
MkGu5+AXV+Xoe6pWQd5kP1UZ44boBZH9FvOLArA4nnF2hsx4GYcxVXBvCCgUqv26
qrGpaSu9kRpuTY5r6CFdjTNWtwGsPaPC
=T8PE
-----END PGP PUBLIC KEY BLOCK-----
EOF
}

# Fix: hardcode jammy — lsb_release returns wrong codename (e.g. "questing") in proot
CODENAME="jammy"

# Fix: remove duplicate/wrong source files if exist
rm -f /etc/apt/sources.list.d/mozillateam-ubuntu-ppa-questing.list
rm -f /etc/apt/sources.list.d/mozillateam-ubuntu-ppa-noble.list
rm -f /etc/apt/sources.list.d/mozillateam-ubuntu-ppa-jammy.list

echo "deb https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu ${CODENAME} main" | \
	tee /etc/apt/sources.list.d/mozillateam-ubuntu-ppa-${CODENAME}.list

print_key | gpg --dearmor > /etc/apt/trusted.gpg.d/firefox.gpg 2>/dev/null

if [ ! -f "$PREFFILE" ]; then
	mkdir -p /etc/apt/preferences.d/
	cat > "$PREFFILE" <<EOF
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
EOF
fi

echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | \
	tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

# Fix: set DISPLAY before install
export DISPLAY=:1

apt-get update
apt install firefox -y

# Fix: apply --no-sandbox for proot/root environment
for desktop_file in /usr/share/applications/firefox.desktop /usr/lib/firefox/firefox.desktop; do
	if [ -f "$desktop_file" ]; then
		sed -i 's|Exec=firefox %u|Exec=firefox --no-sandbox %u|g' "$desktop_file"
		sed -i 's|Exec=firefox %U|Exec=firefox --no-sandbox %U|g' "$desktop_file"
		sed -i 's|Exec=firefox$|Exec=firefox --no-sandbox|g' "$desktop_file"
	fi
done

echo "Firefox installation complete."
