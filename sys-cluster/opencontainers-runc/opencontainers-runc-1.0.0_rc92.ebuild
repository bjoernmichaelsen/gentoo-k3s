# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="CLI tool for spawning and running containers according to the OCI specification"
HOMEPAGE="https://github.com/opencontainers/runc"
MY_PV="1.0.0-rc92"

#go-module_set_globals
#SRC_URI="https://github.com/opencontainers/runc/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz ${EGO_SUM_SRC_URI}"
SRC_URI="https://github.com/opencontainers/runc/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="hardened"

DEPEND="${COMMON_DEPEND}"
BDEPEND="dev-lang/go"
S="${WORKDIR}/runc-1.0.0-rc92"

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
	LDFLAGS="-w -s -X main.version=${MY_PV}" \
	go build "-mod=vendor" "-buildmode=pie"  -tags "apparmor seccomp" -o runc .
}

src_install() {
	dobin runc
}
