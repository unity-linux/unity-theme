NAME=unity-theme
# Bump RELEASE for new Mageia release
# Bump THEMEVER for new theme version in same release
RELEASE=1
THEMEVER=1
DISTREL=6
VERSION=$(RELEASE).$(THEMEVER)

THEMES=Unity-Default

configdir=/etc
libexecdir=/usr/libexec
sharedir=/usr/share
unitdir=/usr/lib/systemd/system
RPMBUILD=$(shell which rpmbuild)
CAT=$(shell which cat)
SED=$(shell which sed)
RM=$(shell which rm)

all:

install:
	mkdir -p $(DESTDIR)$(sharedir)/mga/screensaver
	mkdir -p $(DESTDIR)$(sharedir)/mga/backgrounds
	install -m 644 common/screensaver/*.jpg $(DESTDIR)$(sharedir)/mga/screensaver
	install -m 644 extra-backgrounds/*.jpg $(DESTDIR)$(sharedir)/mga/backgrounds
	@for t in $(THEMES); do \
		set -x; set -e; \
		install -d $(DESTDIR)$(sharedir)/plymouth/themes/$$t; \
		install -m644 common/plymouth/*.script $(DESTDIR)$(sharedir)/plymouth/themes/$$t/; \
		install -m644 common/plymouth/*.png $(DESTDIR)$(sharedir)/plymouth/themes/$$t/; \
		install -m644 $$t/plymouth/*.plymouth $(DESTDIR)$(sharedir)/plymouth/themes/$$t/; \
		install -m644 $$t/plymouth/*.png $(DESTDIR)$(sharedir)/plymouth/themes/$$t/; \
		install -m644 $$t/background/$$t-*.png $(DESTDIR)$(sharedir)/mga/backgrounds/; \
		install -d $(DESTDIR)$(sharedir)/gfxboot/themes/$$t;  \
		install -m644 $$t/gfxboot/*.jpg $(DESTDIR)$(sharedir)/gfxboot/themes/$$t/; \
	done

	@mkdir -p $(DESTDIR)$(libexecdir)
	@mkdir -p $(DESTDIR)$(unitdir)
	install -m755 mga-bg-res/mga-bg-res.sh $(DESTDIR)$(libexecdir)/mga-bg-res
	install -m644 mga-bg-res/mga-bg-res.service $(DESTDIR)$(unitdir)/mga-bg-res.service


$(NAME).spec: $(NAME).spec.in
	@$(CAT) $(NAME).spec.in | \
		$(SED) -e 's,@THEMEVER@,$(THEMEVER),g' | \
		$(SED) -e 's,@RELEASE@,$(RELEASE),g' | \
		$(SED) -e 's,@DISTREL@,$(DISTREL),g'  \
			>$(NAME).spec
	@echo
	@echo "$(NAME).spec generated in $$PWD"
	@echo

spec: $(NAME).spec

dist: cleandist export

cleandist:
	rm -rf $(NAME)-$(VERSION) $(NAME)-$(VERSION).tar.xz

export:
	@$(RM) -rf SRPMS
	@$(RM) -rf $(NAME)-$(VERSION)
	@$(RM) -rf $(NAME)-$(VERSION).tar.xz*
	@find -name '*~' -exec $(RM) {} \;
	@echo
	@echo "Cleaning complete"
	@echo
	git archive --prefix $(NAME)-$(VERSION)/ HEAD > $(NAME)-$(VERSION).tar
	tar -rf $(NAME)-$(VERSION).tar $(NAME).spec
	xz -9 $(NAME)-$(VERSION).tar

srpm: spec export
	$(RPMBUILD) "--define" "_topdir $(shell pwd)" -ts $(NAME)-$(VERSION).tar.xz --clean
	@$(RM) -rf SOURCES SPECS BUILD BUILDROOT RPMS

clean:
	@$(RM) -f *.spec
	@$(RM) -rf SRPMS RPMS SOURCES SPECS BUILD BUILDROOT
	@$(RM) -rf $(NAME)-$(VERSION)
	@$(RM) -rf $(NAME)-$(VERSION).tar.xz*
	@find -name '*~' -exec $(RM) {} \;
	@echo
	@echo "Cleaning complete"
	@echo

