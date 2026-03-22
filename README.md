<div align="center">

```
  _  _  _   __  _  _  ___ ____     _  _  _  _ _  _ ____ ____ ___  
  |__|  |  |    |_/  |___ |__/     |  |  |  | |\ | |__| |___ |  \ 
  |  |  |  |__  | \_ |___ |  \     |__|  |__| | \| |  | |___ |__/ 
```

### A modded GUI version of Ubuntu for Termux — by Junaed Ahmad

<br>

![GitHub repo size](https://img.shields.io/github/repo-size/hgdjunaed65456-netizen/My-Modded-Ubuntu-)
![GitHub stars](https://img.shields.io/github/stars/hgdjunaed65456-netizen/My-Modded-Ubuntu-?style=social)
![GitHub forks](https://img.shields.io/github/forks/hgdjunaed65456-netizen/My-Modded-Ubuntu-?style=social)
![License](https://img.shields.io/github/license/hgdjunaed65456-netizen/My-Modded-Ubuntu-)

</div>

---

## 📌 What is this?

**My Modded Ubuntu** is a customized Ubuntu 22.04 (Jammy) setup script for **Termux** on Android. It installs a full **XFCE4 GUI desktop environment** accessible via **VNC Viewer**, with your choice of browser, IDE, and media player — all with bugs fixed for smooth proot/Termux compatibility.

---

## ✨ Features

- 🖥️ **XFCE4 Desktop Environment** via VNC
- 🦊 **Firefox** or 🌐 **Chromium** browser (with `--no-sandbox` fix)
- 💻 **VSCode** or **Sublime Text** IDE support
- 🎬 **MPV** or **VLC** media player
- 🔊 Sound support via PulseAudio
- 🔧 All major bugs fixed (DISPLAY, VNC lock, browser launch issues)
- 🎨 Custom theme, icons, fonts & wallpaper

---

## 📋 Requirements

- Android device with **Termux** installed (from [F-Droid](https://f-droid.org/packages/com.termux/), NOT Play Store)
- **VNC Viewer** app installed on your device ([Download here](https://play.google.com/store/apps/details?id=com.realvnc.viewer.android))
- Stable internet connection
- At least **4GB** free storage

---

## ⚡ Installation

### Step 1 — Setup Termux

Open Termux and run:

```bash
pkg update -y && pkg upgrade -y
pkg install git -y
```

### Step 2 — Clone this repo

```bash
git clone https://github.com/hgdjunaed65456-netizen/My-Modded-Ubuntu-.git
cd My-Modded-Ubuntu-
```

### Step 3 — Run setup

```bash
bash setup.sh
```

> This will install Ubuntu 22.04 with proot-distro and set up the environment.

### Step 4 — Enter Ubuntu & setup user

After setup, restart Termux. Then:

```bash
ubuntu
```

Inside Ubuntu, run:

```bash
bash user.sh
```

> Enter your desired username and password when prompted.

### Step 5 — Install GUI

After user setup, restart Termux again and log in:

```bash
ubuntu
```

Then run:

```bash
sudo bash gui.sh
```

> This will install XFCE4, your chosen browser, IDE, and media player.

---

## 🖥️ Using the Desktop

### Start VNC Server

```bash
vncstart
```

### Stop VNC Server

```bash
vncstop
```

### Connect via VNC Viewer

1. Open **VNC Viewer** on your Android device
2. Tap the **+** button
3. Set Address: `localhost:1`
4. Set Name: anything you like (e.g. `My Ubuntu`)
5. Set Picture Quality to **High**
6. Tap **Connect** and enter your VNC password

---

## 🌐 Opening Browser

If browser does not open from the desktop, run this in the Ubuntu terminal:

```bash
export DISPLAY=:1
firefox --no-sandbox &
```

Or for Chromium:

```bash
export DISPLAY=:1
chromium --no-sandbox &
```

---

## 🗑️ Uninstall

To completely remove Ubuntu from Termux:

```bash
bash remove.sh
```

---

## 📁 File Structure

```
My-Modded-Ubuntu-/
├── setup.sh                 → Main installer (run from Termux)
├── remove.sh                → Uninstaller
├── distro/
│   ├── gui.sh               → GUI installer (run inside Ubuntu)
│   ├── user.sh              → User setup script (run inside Ubuntu)
│   ├── firefox.sh           → Firefox installer
│   ├── vncstart             → Start VNC server
│   ├── vncstop              → Stop VNC server
│   └── proot-distro.sh      → Proot-distro utility
└── patches/
    └── code.desktop         → VSCode desktop fix for proot
```

---

## 🐛 Bugs Fixed

| Bug | Fix |
|-----|-----|
| Browser not opening after VNC connect | Fixed `DISPLAY=:1` environment variable |
| Firefox crash on launch | Added `--no-sandbox` flag |
| VNC server conflict on restart | Lock files cleaned on `vncstop` |
| `/username/` path error in vncstop | Replaced with `$HOME` |
| Password shown on screen during user setup | Added `-s` flag to `read` |
| `chmod` not applied to ubuntu binary | Uncommented `chmod +x` line |
| Duplicate sound entries on re-run | Added `grep` check before appending |
| Ubuntu version hardcoded in Firefox PPA | Dynamic `lsb_release` detection |

---

## 📸 Screenshots

> Coming soon...

---

## 👤 Author

**Junaed Ahmad**
- GitHub: [@hgdjunaed65456-netizen](https://github.com/hgdjunaed65456-netizen)

---

## 📜 License

This project is licensed under the **GPL-3.0 License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <b>⭐ If you find this useful, please give it a star! ⭐</b>
</div>
