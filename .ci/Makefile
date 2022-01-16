DOCKERID=bjoernmichaelsen
MAKEDIR:=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
REPODIR:=$(realpath $(MAKEDIR)/..)
BUILDDIR?=./build
PKG_VERSION=$(patsubst %.ebuild,%,$(notdir $(wildcard $(REPODIR)/sys-cluster/k3s/k3s*.ebuild)))

$(BUILDDIR)/$(PKG_VERSION).tbz2: $(BUILDDIR)/.dir
	cp $(MAKEDIR)/../Dockerfile $(BUILDDIR)
	cd $(BUILDDIR) && docker build -t $(DOCKERID)/$(notdir $@) .
	docker run --rm $(DOCKERID)/$(notdir $@) cat /var/cache/binpkgs/sys-cluster/$(notdir $@) > $@

$(BUILDDIR)/.dir:
	mkdir -p $(BUILDDIR)
	touch $@

clean:
	rm -rf $(BUILDDIR)/.dir $(BUILDDIR)/$(PKG_VERSION).tbz2 $(BUILDDIR)/Dockerfile $(BUILDDIR)/repos.conf.append $(BUILDDIR)/k3s-overlay
