.include <bsd.cpu.mk>

ARCH=$(MACHINE_CPUARCH)
DOWNLOAD_URI=https://download.freebsd.org
DOWNLOAD_SNAPSHOTS_PATH=ftp/snapshots
DOWNLOAD_VERSION!=uname -r

SNAPSHOTS_BIN=kernel.txz base.txz
SNAPSHOTS_SRC=src.txz
SNAPSHOTS_REVISION=REVISION
SNAPSHOTS=$(SNAPSHOTS_BIN) $(SNAPSHOTS_SRC) $(SNAPSHOTS_REVISION)
SNAPSHOTS_BIN_DEBUG=$(SNAPSHOTS_BIN:S/./-dbg./g)
SNAPSHOTS_DEBUG=$(SNAPSHOTS_BIN_DEBUG)

default: fetch

download:
	fetch $(DOWNLOAD_URI)/$(DOWNLOAD_SNAPSHOTS_PATH)/$(ARCH)/$(DOWNLOAD_VERSION)/$(DOWNLOADFILE)

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
