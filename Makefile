SUBDIRS =
DESTDIR = 
UBINDIR ?= /usr/bin
ULIBDIR ?= /usr/lib/vasile

all:
	for d in $(SUBDIRS); do $(MAKE) -C $$d; done

clean:
	for d in $(SUBDIRS); do $(MAKE) -C $$d clean; done

install:
	for d in $(SUBDIRS); do $(MAKE) -C $$d install; done

	install -d $(DESTDIR)$(UBINDIR)
	install -m 0755 src/frontend/cli/vasile.sh $(DESTDIR)$(UBINDIR)/
	install -d $(DESTDIR)$(ULIBDIR)
	install -m 0644 src/backend/*sh $(DESTDIR)$(ULIBDIR)/

uninstall:
	rm -rf $(DESTDIR)$(UBINDIR)/vasile.sh
	rm -rf $(DESTDIR)$(ULIBDIR)
