# DPT-RP1 CUPS printer


# Installation

```bash
sudo make install
```

To add a new DPT-RP1 as printer do:

```bash
lpadmin -L 'DPT-RP1 WiFi' -D 'DPT-RP1 WiFi Printer' \
		-p 'DPT-RP1-WiFi' -E -v 'dptrp1:192.168.1.101'
```

Replace `192.168.1.101` with the correct address assigned to your DPT-RP1.
