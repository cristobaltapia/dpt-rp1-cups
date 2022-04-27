.PHONY: install, uninstall, add, remove

DPTRP1PATH=$(shell which dptrp1)

build: ppd/dptrp1.ppd

ppd/dptrp1.ppd: dptrp1.drv
	ppdc -d ppd dptrp1.drv

install: ppd/dptrp1.ppd
	install ppd/dptrp1.ppd /usr/share/cups/model/
	install dptrp1.sh /usr/lib/cups/backend/dptrp1
	sed -i 's:dptrp1path=:dptrp1path=$(DPTRP1PATH):g' /usr/lib/cups/backend/dptrp1
	chmod 700 /usr/lib/cups/backend/dptrp1
	install icons/dptrp1.svg /usr/share/pixmaps/dptrp1-cups.svg

uninstall:
	rm /usr/share/cups/model/dptrp1.ppd
	rm /usr/lib/cups/backend/dptrp1
	rm /usr/share/pixmaps/dptrp1-cups.svg

add:
	lpadmin -L 'DPT-RP1 WiFi' -D 'DPT-RP1 WiFi Printer' \
		-p 'DPT-RP1-WiFi' -E -v 'dptrp1:192.168.1.101'

remove:
	lpadmin -x 'DPT-RP1-WiFi'
