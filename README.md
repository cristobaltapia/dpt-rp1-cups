# DPT-RP1 CUPS backend

![DPT-RP1-cups](icons/dptrp1.png)

This CUPS backend allows to print directly to your Sony DPT-RP1 or DPT-CP1 devices, or to the newer Fujitsu Quaderno (all versions).
I took the idea from the equivalent backend for the [remarkable](https://github.com/ofosos/scratch/tree/master/remarkable-cups).
To use this you need to first install and configure [dpt-rp1-py](https://github.com/janten/dpt-rp1-py).


## Additional dependencies

* [notify-send.sh](https://github.com/vlevit/notify-send.sh)

# Installation

## Archlinux

```
yay -S dpt-rp1-cups
```

## Other distributions

```bash
sudo make DESTDIR=/ install
```

The backend assumes that your client-id and key files required by `dpt-rp1-py` are located at `~/.config/dpt/deviceid.dat` and `~/.config/dpt/privatekey.dat`, respectively.

To add a new DPT-RP1 as printer:

```bash
lpadmin -L 'DPT-RP1 WiFi' -D 'DPT-RP1 WiFi Printer' \
    -p 'DPT-RP1-WiFi' -E -v 'dptrp1:192.168.1.101'
```

Replace `192.168.1.101` with the correct address assigned to your device.
You can also give the corresponding bluetooth address.

If you own one of the A5 versions (DPT-CP1 or Quaderno A5), you would add the new printer with the following command:

```bash
lpadmin -L 'DPT-RP1 WiFi' -D 'DPT-RP1 WiFi Printer' \
    -p 'DPT-RP1-WiFi' -E -v 'dptcp1:192.168.1.101'
```

Notice the option `-v dptcp1:192.168.1.101`.

![Print dialog](dptrp1-cups.png)
