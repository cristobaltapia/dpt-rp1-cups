.PHONY: install, uninstall, add, remove

DPTRP1PATH=$(shell which dptrp1)

build: ppd/dptrp1.ppd

ppd/dptrp1.ppd: dptrp1.drv
	ppdc -d ppd dptrp1.drv

install: ppd/dptrp1.ppd
	install -D ppd/dptrp1.ppd $(DESTDIR)usr/share/cups/model/
	install -D dptrp1.sh $(DESTDIR)usr/lib/cups/backend/dptrp1
	sed -i 's:dptrp1path=:dptrp1path=$(DPTRP1PATH):g' $(DESTDIR)usr/lib/cups/backend/dptrp1
	chmod 700 $(DESTDIR)usr/lib/cups/backend/dptrp1
	install icons/dptrp1.svg $(DESTDIR)usr/share/pixmaps/dptrp1-cups.svg

uninstall:
	rm $(DESTDIR)usr/share/cups/model/dptrp1.ppd
	rm $(DESTDIR)usr/lib/cups/backend/dptrp1
	rm $(DESTDIR)usr/share/pixmaps/dptrp1-cups.svg

add:
	lpadmin -L 'DPT-RP1 WiFi' -D 'DPT-RP1 WiFi Printer' \
		-p 'DPT-RP1-WiFi' -E -v 'dptrp1:192.168.1.101'

png:
	inkscape --export-png=icons/dptrp1.png -d 300 icons/dptrp1.svg

remove:
	lpadmin -x 'DPT-RP1-WiFi'
