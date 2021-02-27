FROM bjoernmichaelsen/gentoo-go:latest

COPY k3s-overlay/ /var/db/repos/k3s-overlay/
COPY repos.conf.append /etc/portage/repos.conf.append
RUN sh -c "cat /etc/portage/repos.conf.append >> /etc/portage/repos.conf"
RUN ACCEPT_KEYWORDS="~amd64" emerge -b k3s
