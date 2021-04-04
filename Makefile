.PHONY: install, uninstall, build, add, remove

build: ppd/dptrp1.ppd

ppd/dptrp1.ppd: dptrp1.drv
	ppdc -d ppd dptrp1.drv

install: ppd/dptrp1.ppd
	install ppd/dptrp1.ppd /usr/share/cups/model/
	install dptrp1.sh /usr/lib/cups/backend/dptrp1
	chmod 700 /usr/lib/cups/backend/dptrp1

uninstall:
	rm /usr/share/cups/model/dptrp1.ppd
	rm /usr/lib/cups/backend/dptrp1

add:
	lpadmin -L 'DPT-RP1 WiFi' -D 'DPT-RP1 WiFi Printer' \
		-p 'DPT-RP1-WiFi' -E -v 'dptrp1:192.168.1.101'

remove:
	lpadmin -x 'DPT-RP1-WiFi'
