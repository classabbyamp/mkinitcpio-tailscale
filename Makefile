DESTDIR:=
PREFIX:=/usr

INITCPIO:=lib/initcpio

.PHONY: install

install:
	install -D -m 0644 -T tailscale_hook "$(DESTDIR)/$(PREFIX)/$(INITCPIO)/hooks/tailscale"
	install -D -m 0644 -T tailscale_install "$(DESTDIR)/$(PREFIX)/$(INITCPIO)/install/tailscale"
