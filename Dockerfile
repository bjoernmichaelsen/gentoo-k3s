FROM bjoernmichaelsen/gentoo-go:latest

RUN ACCEPT_KEYWORDS="~amd64" emerge -b k3s
