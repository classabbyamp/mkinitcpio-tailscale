DESTDIR:=
PREFIX:=usr
BINDIR:=bin
INITCPIO:=lib/initcpio

.PHONY: install

install:
	install -D -m 0644 -T tailscale_hook "$(DESTDIR)/$(PREFIX)/$(INITCPIO)/hooks/tailscale"
	install -D -m 0644 -T tailscale_install "$(DESTDIR)/$(PREFIX)/$(INITCPIO)/install/tailscale"
	install -D -m 0755 -T mkinitcpio-tailscale-setup "$(DESTDIR)/$(PREFIX)/$(BINDIR)/mkinitcpio-tailscale-setup"
