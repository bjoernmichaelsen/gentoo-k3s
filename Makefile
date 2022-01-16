DOCKERID:=bjoernmichaelsen
BUILDDIR?=./build
BUILD_DATE:=$(shell date -I)
IMAGE_REPO:=$(DOCKERID)/gentoo-k3s
IMAGE_TAG:=nightly-$(BUILD_DATE)
MAKEOPTS:="-j3"

all: $(BUILDDIR)/environment.bz2 $(BUILDDIR)/Manifest
	@true

$(BUILDDIR)/environment.bz2: $(BUILDDIR)/gentoo-k3s.cid
	docker run --entrypoint /bin/sh --rm $(IMAGE_REPO):$(IMAGE_TAG) -c 'cat $$(find /var/db/pkg/sys-cluster/ -name $(notdir $@) |grep k3s)' > $@

$(BUILDDIR)/Manifest: $(BUILDDIR)/gentoo-k3s.cid
	docker run --entrypoint /bin/cat --rm $(IMAGE_REPO):$(IMAGE_TAG) /var/db/repos/gentoo/Manifest > $@

$(BUILDDIR)/gentoo-k3s.cid: $(BUILDDIR)/.dir
	cp Dockerfile $(BUILDDIR)
	cd $(BUILDDIR) && docker build . -t $(IMAGE_REPO):$(IMAGE_TAG)
	docker tag $(IMAGE_REPO):$(IMAGE_TAG) $(IMAGE_REPO):`docker run --entrypoint /bin/sh $(IMAGE_REPO):$(IMAGE_TAG) -c "k3s --version|grep ^k3s|cut -f3 -d\ |sed s/+k3s-//"`
	touch $@

$(BUILDDIR)/.dir:
	mkdir -p $(BUILDDIR)
	touch $@

clean:
	rm -f $(BUILDDIR)/Manifest $(BUILDDIR)/gentoo-k3s.cid $(BUILDDIR)/environment.bz2 $(BUILDDIR)/.dir

push-image:
	echo "$${REGISTRY_PASSWORD}" | docker login --username "$${REGISTRY_USERNAME}" --password-stdin
	docker push $(IMAGE_REPO)

.PHONY: all clean push-image
