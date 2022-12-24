ARCH=amd64
SNAPSHOTS_BIN=kernel.txz base.txz
SNAPSHOTS_SRC=src.txz
SNAPSHOTS=$(SNAPSHOTS_BIN) $(SNAPSHOTS_SRC)
SNAPSHOTS_BIN_DEBUG=$(SNAPSHOTS_BIN:S/./-dbg./g)
SNAPSHOTS_DEBUG=$(SNAPSHOTS_BIN_DEBUG)

default: fetch

download:
	fetch https://download.freebsd.org/ftp/snapshots/${ARCH}/14.0-CURRENT/$(DOWNLOADFILE)

.for i in $(SNAPSHOTS) $(SNAPSHOTS_DEBUG)
$i:
	@$(MAKE) DOWNLOADFILE=$@ download
.endfor

fetch: $(SNAPSHOTS)

fetch-debug: $(SNAPSHOTS_DEBUG)


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
