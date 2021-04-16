# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="industry-standard container runtime -- k3s parts only"
HOMEPAGE="https://github.com/k3s-io/containerd"
MY_PV="1.4.3-k3s1"

EGO_SUM=(
  "github.com/k3s-io/containerd v${MY_PV}/go.mod"
  "github.com/k3s-io/containerd v${MY_PV}"
)
go-module_set_globals
SRC_URI="https://github.com/k3s-io/containerd/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz ${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="hardened"

DEPEND="${COMMON_DEPEND}"
BDEPEND="dev-lang/go"

src_unpack() {
	default_src_unpack
	mv containerd* ${P}
}

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
	LDFLAGS="-w -s" \
	CGO_ENABLED=0 go build -o containerd-shim ./cmd/containerd-shim
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
	LDFLAGS="-w -s" \
	CGO_ENABLED=0 go build -o containerd-shim-runc-v2 ./cmd/containerd-shim-runc-v2
}

src_install() {
	newbin containerd-shim containerd-shim
	newbin containerd-shim-runc-v2 containerd-shim-runc-v2
}
