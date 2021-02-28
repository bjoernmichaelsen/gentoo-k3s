# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="CLI tool for spawning and running containers according to the OCI specification"
HOMEPAGE="https://github.com/opencontainers/runc"
MY_PV="1.0.0-rc92"

EGO_SUMS=(
	"https://github.com/opencontainers/runc v${MY_PV}/go.mod"
	"https://github.com/opencontainers/runc v${MY_PV}"
)
go-module_set_globals
SRC_URI="https://github.com/opencontainers/runc/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz ${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="hardened"

DEPEND="${COMMON_DEPEND}"
BDEPEND="dev-lang/go"
src_unpack() {
	default_src_unpack
	mv runc* ${P}
}
src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
	LDFLAGS="-w -s -X main.version=${MY_PV}" \
	go build "-mod=vendor" "-buildmode=pie"  -tags "apparmor seccomp" -o runc .
}

src_install() {
	newbin runc runc
}
