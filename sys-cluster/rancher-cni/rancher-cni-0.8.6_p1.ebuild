# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="Rancher CNI plugins"
HOMEPAGE="https://github.com/rancher/plugins"
MY_PV="0.8.6-k3s1"

#go-module_set_globals
SRC_URI="https://github.com/rancher/plugins/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="hardened"

DEPEND="${COMMON_DEPEND}"
BDEPEND="dev-lang/go"
S="${WORKDIR}/plugins-${MY_PV}"

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
	LDFLAGS="-w -s" \
	CGO_ENABLED=0 go build -mod=vendor -tags 'ctrd apparmor seccomp no_btrfs netcgo osusergo providerless' -ldflags '-w -s' -o cni
}

src_install() {
	dobin cni
	dosym /usr/bin/cni /usr/bin/bridge
	dosym /usr/bin/cni /usr/bin/flannel
	dosym /usr/bin/cni /usr/bin/host-local
	dosym /usr/bin/cni /usr/bin/loopback
	dosym /usr/bin/cni /usr/bin/portmap
}
