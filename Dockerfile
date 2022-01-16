FROM bjoernmichaelsen/gentoo-go:latest

RUN USE="-pam static static-libs" emerge busybox
RUN ACCEPT_KEYWORDS="~amd64" emerge -b k3s
ENTRYPOINT ["k3s", "server", "--snapshotter=native"]
