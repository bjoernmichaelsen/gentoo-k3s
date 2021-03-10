# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module linux-info

DESCRIPTION="Lightweight Kubernetes: Production ready, easy to install, half the memory."
HOMEPAGE="https://github.com/k3s-io/k3s"
MY_PV="1.20.0+k3s2"

SRC_URI="https://github.com/k3s-io/k3s/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
PATCHES=(
	"${FILESDIR}/0001-remove-repo-external-builds.patch"
)

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND="${COMMON_DEPEND}"
BDEPEND="dev-lang/go"
S="${WORKDIR}/k3s-1.20.0-k3s2"

CONFIG_CHECK="~MEMCG ~CGROUP_PIDS ~BRIDGE_NETFILTER ~OVERLAY_FS ~IP_VS ~CFS_BANDWIDTH ~VXLAN ~VLAN"

src_compile() {
	mkdir -p build/data && ./scripts/download && go generate
	./scripts/build
}

src_install() {
	dobin bin/containerd
	dosym containerd /usr/bin/k3s
	dosym containerd /usr/bin/k3s-agent
	dosym containerd /usr/bin/k3s-server
	dosym containerd /usr/bin/kubectl
	dosym containerd /usr/bin/crictl
	dosym containerd /usr/bin/ctr
}
