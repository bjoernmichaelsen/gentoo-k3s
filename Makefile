DOCKERID:=bjoernmichaelsen
BUILDDIR?=./build
BUILD_DATE:=$(shell date -I)
IMAGE_REPO:=$(DOCKERID)/gentoo-k3s
IMAGE_TAG:=nightly-$(BUILD_DATE)
IMAGE_TAG_MINIMAL:=$(IMAGE_TAG)-minimal
MAKEOPTS:="-j3"

all: $(BUILDDIR)/environment.bz2 $(BUILDDIR)/Manifest $(BUILDDIR)/gentoo-k3s-minimal.tag
	@true

$(BUILDDIR)/environment.bz2: $(BUILDDIR)/gentoo-k3s.tag
	docker run --entrypoint /bin/sh --rm $(IMAGE_REPO):$(IMAGE_TAG) -c 'cat $$(find /var/db/pkg/sys-cluster/ -name $(notdir $@) |grep k3s)' > $@

$(BUILDDIR)/Manifest: $(BUILDDIR)/gentoo-k3s.tag
	docker run --entrypoint /bin/cat --rm $(IMAGE_REPO):$(IMAGE_TAG) /var/db/repos/gentoo/Manifest > $@

$(BUILDDIR)/gentoo-k3s.tag: $(BUILDDIR)/.dir
	cp Dockerfile $(BUILDDIR)
	cd $(BUILDDIR) && docker build . -t $(IMAGE_REPO):$(IMAGE_TAG)
	docker run --entrypoint /bin/sh $(IMAGE_REPO):$(IMAGE_TAG) -c "k3s --version|grep ^k3s|cut -f3 -d\ |sed s/+k3s-//" > $@
	docker tag $(IMAGE_REPO):$(IMAGE_TAG) $(IMAGE_REPO):$$(cat $@)

$(BUILDDIR)/gentoo-k3s-minimal.tag: $(BUILDDIR)/gentoo-k3s.tag
	cp Dockerfile.minimal $(BUILDDIR)
	cd $(BUILDDIR) && docker build . -f Dockerfile.minimal -t $(IMAGE_REPO):$(IMAGE_TAG_MINIMAL)
	echo "$$(cat $<)-minimal" > $@
	docker tag $(IMAGE_REPO):$(IMAGE_TAG_MINIMAL) $(IMAGE_REPO):$$(cat $@)

$(BUILDDIR)/.dir:
	mkdir -p $(BUILDDIR)
	touch $@

clean:
	rm -f $(BUILDDIR)/Manifest $(BUILDDIR)/gentoo-k3s.tag $(BUILDDIR)/gentoo-k3s-minimal.tag $(BUILDDIR)/environment.bz2 $(BUILDDIR)/Dockerfile $(BUILDDIR)/Dockerfile.minimal $(BUILDDIR)/.dir

push-image:
	echo "$${REGISTRY_PASSWORD}" | docker login --username "$${REGISTRY_USERNAME}" --password-stdin
	docker push $(IMAGE_REPO)

.PHONY: all clean push-image
