default: fetch

kernel.txz:
	fetch https://download.freebsd.org/ftp/snapshots/amd64/14.0-CURRENT/kernel.txz
base.txz:
	fetch https://download.freebsd.org/ftp/snapshots/amd64/14.0-CURRENT/base.txz
src.txz:
	fetch https://download.freebsd.org/ftp/snapshots/amd64/14.0-CURRENT/src.txz

SNAPSHOTS=kernel.txz base.txz src.txz

fetch: $(SNAPSHOTS)

clean:
	pwd
	rm -f $(SNAPSHOTS)

chflags-noschg:
	sudo chflags noschg $$(cat schg.lst)
chflags-schg:
	sudo chflags schg $$(cat schg.lst)

extract:
	sudo tar -xp --exclude ./var/empty -f base.txz -C / --exclude './etc/*'
	sudo mv /boot/kernel /boot/kernel.$$(date "+%Y%m%d%H%M%S")
	sudo tar -xp -f kernel.txz -C / 
	sudo tar -xp -f src.txz -C / 

install: chflags-noschg extract chflags-schg
