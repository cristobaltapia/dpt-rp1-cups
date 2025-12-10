# DPT-RP1 CUPS Backend

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

![DPT-RP1-cups](icons/dptrp1.png)

A CUPS backend that enables direct printing to Sony Digital Paper devices (DPT-RP1, DPT-CP1) and Fujitsu Quaderno e-readers. Print documents from any application directly to your device over WiFi or Bluetooth.

---

## Table of Contents

- [Features](#features)
- [Supported Devices](#supported-devices)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Arch Linux](#arch-linux)
  - [Other Linux Distributions](#other-linux-distributions)
- [Configuration](#configuration)
  - [Setting up dpt-rp1-py](#setting-up-dpt-rp1-py)
  - [Adding a Printer](#adding-a-printer)
- [Usage](#usage)
- [Uninstallation](#uninstallation)
- [How It Works](#how-it-works)
- [License](#license)
- [Acknowledgments](#acknowledgments)

---

## Features

- **Direct printing** to Sony Digital Paper and Fujitsu Quaderno devices
- **WiFi and Bluetooth** connectivity support
- **Automatic PDF optimization** - preserves original PDFs when possible
- **Desktop notifications** when printing completes
- **Organized storage** - prints are saved to `Document/Printed/` folder on device
- **One-click display** - notification action to open document on device
- **Timestamped filenames** - automatic naming with date and time

---

## Supported Devices

- Sony DPT-RP1 (A4 size)
- Sony DPT-CP1 (A5 size)
- Fujitsu Quaderno (all versions)

---

## Prerequisites

Before installing this CUPS backend, ensure you have the following:

### Required Software

1. **CUPS** - Common UNIX Printing System
   ```bash
   # Debian/Ubuntu
   sudo apt install cups
   
   # Arch Linux
   sudo pacman -S cups
   
   # Fedora
   sudo dnf install cups
   ```

2. **[dpt-rp1-py](https://github.com/janten/dpt-rp1-py)** - Python library for DPT devices
   ```bash
   pip install dpt-rp1-py
   ```

3. **[notify-send.sh](https://github.com/vlevit/notify-send.sh)** - Enhanced notification script
   ```bash
   # Download and install notify-send.sh
   curl -o /usr/local/bin/notify-send.sh https://raw.githubusercontent.com/vlevit/notify-send.sh/master/notify-send.sh
   chmod +x /usr/local/bin/notify-send.sh
   ```

4. **ppdc** - PPD compiler (usually included with CUPS development packages)
   ```bash
   # Debian/Ubuntu
   sudo apt install cups-ppdc
   
   # Arch Linux
   sudo pacman -S cups
   
   # Fedora
   sudo dnf install cups-devel
   ```

### System Requirements

- Linux operating system
- CUPS service running
- Network connectivity to your device (WiFi or Bluetooth)

---

## Installation

### Arch Linux

The easiest way to install on Arch Linux is via the AUR:

```bash
yay -S dpt-rp1-cups
```

### Other Linux Distributions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/cristobaltapia/dptrp1-cups.git
   cd dptrp1-cups
   ```

2. **Build and install:**
   ```bash
   sudo make DESTDIR=/ install
   ```

   This will:
   - Compile the PPD (PostScript Printer Description) file
   - Install the CUPS backend to `/usr/lib/cups/backend/`
   - Install the PPD file to `/usr/share/cups/model/`
   - Install the icon to `/usr/share/pixmaps/`

3. **Restart CUPS service:**
   ```bash
   sudo systemctl restart cups
   ```

---

## Configuration

### Setting up dpt-rp1-py

Before you can use this CUPS backend, you must configure `dpt-rp1-py` to authenticate with your device.

1. **Register your computer with the device:**
   ```bash
   dptrp1 --addr <device-ip-address> register
   ```

2. **Follow the on-screen instructions** - you'll need to enter a code displayed on your device.

3. **Verify the configuration files** are created:
   ```bash
   ls ~/.config/dpt/
   # Should show: deviceid.dat  privatekey.dat
   ```

The backend expects these files at:
- **Device ID:** `~/.config/dpt/deviceid.dat`
- **Private Key:** `~/.config/dpt/privatekey.dat`

### Adding a Printer

#### For A4 Devices (DPT-RP1, Quaderno A4)

```bash
lpadmin -L 'DPT-RP1 WiFi' -D 'DPT-RP1 WiFi Printer' \
    -p 'DPT-RP1-WiFi' -E -v 'dptrp1:192.168.1.101'
```

#### For A5 Devices (DPT-CP1, Quaderno A5)

```bash
lpadmin -L 'DPT-CP1 WiFi' -D 'DPT-CP1 WiFi Printer' \
    -p 'DPT-CP1-WiFi' -E -v 'dptcp1:192.168.1.101'
```

**Important:** Replace `192.168.1.101` with your device's actual IP address.

#### Options Explained

- `-L` : Location description
- `-D` : Human-readable description
- `-p` : Printer name (used in CUPS)
- `-E` : Enable the printer and accept jobs
- `-v` : Device URI
  - Use `dptrp1:` for A4 devices
  - Use `dptcp1:` for A5 devices

#### Finding Your Device's IP Address

On your Sony DPT or Fujitsu Quaderno:
1. Go to **Settings** → **Wi-Fi Settings**
2. Tap on your connected network
3. Note the IP address displayed

#### Using Bluetooth

You can also use Bluetooth by specifying the Bluetooth address:

```bash
lpadmin -L 'DPT-RP1 Bluetooth' -D 'DPT-RP1 Bluetooth Printer' \
    -p 'DPT-RP1-BT' -E -v 'dptrp1:AA:BB:CC:DD:EE:FF'
```

---

## Usage

Once configured, the DPT device will appear as a regular printer in all your applications.

### Printing from Applications

1. Open any document (PDF, LibreOffice, web browser, etc.)
2. Select **Print** (Ctrl+P)
3. Choose your DPT device from the printer list
4. Click **Print**

![Print dialog](dptrp1-cups.png)

### What Happens When You Print

1. The document is converted to PDF (if not already PDF)
2. The file is uploaded to `Document/Printed/` on your device
3. A desktop notification appears with the document name
4. Click the notification to open the document on your device

### File Naming

Printed documents are automatically named with:
- Timestamp: `YYYY-MM-DD_HH-MM`
- Original filename (sanitized)
- Example: `2025-12-10_14-30_report.pdf`

---

## Uninstallation

### Arch Linux

```bash
yay -R dpt-rp1-cups
```

### Other Distributions

1. **Remove the printer from CUPS:**
   ```bash
   lpadmin -x 'DPT-RP1-WiFi'
   ```

2. **Uninstall the backend:**
   ```bash
   cd dptrp1-cups
   sudo make DESTDIR=/ uninstall
   ```

3. **Restart CUPS:**
   ```bash
   sudo systemctl restart cups
   ```

---

## How It Works

This backend integrates with CUPS to provide seamless printing:

1. **CUPS receives print job** from any application
2. **Backend converts** document to PDF (if needed)
3. **Filename is sanitized** and timestamped
4. **dpt-rp1-py uploads** the PDF to the device
5. **Desktop notification** is sent to user
6. **Temporary files** are cleaned up

The backend intelligently handles PDFs:
- If the original file is PDF and all pages are printed, the original is transferred
- Otherwise, CUPS generates a new PDF with only the selected pages

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2025 Cristóbal Tapia

---

## Acknowledgments

- Inspired by the [remarkable-cups](https://github.com/ofosos/scratch/tree/master/remarkable-cups) backend
- Built on top of [dpt-rp1-py](https://github.com/janten/dpt-rp1-py) by janten
- Uses [notify-send.sh](https://github.com/vlevit/notify-send.sh) for enhanced notifications

---

**Enjoy wireless printing to your Digital Paper device!**
