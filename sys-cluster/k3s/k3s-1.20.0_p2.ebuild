# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="Lightweight Kubernetes: Production ready, easy to install, half the memory."
HOMEPAGE="https://github.com/k3s-io/k3s"
MY_PV="1.20.0+k3s2"

EGO_SUMS=(
	"https://github.com/k3s-io/k3s v${MY_PV}/go.mod"
	"https://github.com/k3s-io/k3s v${MY_PV}"
)
go-module_set_globals
SRC_URI="https://github.com/k3s-io/k3s/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz ${EGO_SUM_SRC_URI}"
PATCHES=(
	"${FILESDIR}/0001-remove-repo-external-builds.patch"
)

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND="${COMMON_DEPEND}"
BDEPEND="dev-lang/go"

src_unpack() {
	default_src_unpack
	find .
	mv k3s* ${P}
}

src_compile() {
	mkdir -p build/data && ./scripts/download && go generate
	./scripts/build
	./scripts/package-cli
}

src_install() {
	newbin dist/artifacts/k3s k3s
	dosym k3s /usr/bin/k3s-agent
	dosym k3s /usr/bin/k3s-server
	dosym k3s /usr/bin/kubectl
	dosym k3s /usr/bin/crictl
	dosym k3s /usr/bin/ctr
}
