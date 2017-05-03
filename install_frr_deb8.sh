#!/bin/bash
#
# basic bash script to clone and install frr for debian 8 systems
#
function stop_and_wait()
    {
        read -p "$*"
    }

# Install pythyon prerequsites:

printf "\n"
printf "Installing prerequsite packages:\n"
printf "================================"
printf "\n"

apt-get install git autoconf automake libtool make gawk libreadline-dev texinfo libjson-c-dev pkg-config bison flex python-pip libc-ares-dev python3-dev

printf "\n"
printf "Installing pytest:\n"
printf "=================="
printf "\n"

pip install pytest

# configure the frr user, group and home dir:
printf "\n"
printf "Configuring the frr users, group and home dir:\n"
printf "=============================================="
printf "\n"

addgroup --system --gid 92 frr
addgroup --system --gid 85 frrvty
adduser --system --ingroup frr --home /var/run/frr/ --gecos "FRR suite" --shell /bin/false frr
usermod -a -G frrvty frr

current_dir=$(pwd)

printf "\n"
printf "Cloning the frr Debian 8 git repo into the following directory:"
printf "\n"
printf "$current_dir"
printf "\n"
stop_and_wait 'Press any key to continue or CTRL + C to abort...'
printf "\n"
# Clone git repo into a subdirectory of current dir called frr
git clone https://github.com/frrouting/frr.git frr
printf "\n"
stop_and_wait 'Starting frr installation, press any key to continue or CTRL + C to abort...'
printf "\n"
# start the frr install
cd $current_dir/frr
./bootstrap.sh
printf "\n"
printf "building frr with all th default options"
printf "\n"
# configure
cd $current_dir/frr
./configure --enable-exampledir=/usr/share/doc/frr/examples/ --localstatedir=/var/run/frr --sbindir=/usr/lib/frr --sysconfdir=/etc/frr --enable-vtysh --enable-isisd --enable-pimd --enable-watchfrr --enable-ospfclient=yes --enable-ospfapi=yes --enable-multipath=64 --enable-user=frr --enable-group=frr --enable-vty-group=frrvty --enable-configfile-mask=0640 --enable-logfile-mask=0640 --enable-rtadv --enable-tcp-zebra --enable-fpm --enable-ldpd --with-pkg-git-version --with-pkg-extra-version=-MyOwnFRRVersion

printf "\n"
printf "running make, make check and make install\n"
printf "========================================="
printf "\n"
# make
cd $current_dir/frr
make
cd $current_dir/frr
make check
cd $current_dir/frr
make install

printf "\n"
printf "Install completed, creating the configuration files in /etc/frr/*"
printf "================================================================="
printf "\n"
printf "\n"
# create the frr config files:
install -m 755 -o frr -g frr -d /var/log/frr
install -m 775 -o frr -g frrvty -d /etc/frr
install -m 640 -o frr -g frr /dev/null /etc/frr/zebra.conf
install -m 640 -o frr -g frr /dev/null /etc/frr/bgpd.conf
install -m 640 -o frr -g frr /dev/null /etc/frr/ospfd.conf
install -m 640 -o frr -g frr /dev/null /etc/frr/ospf6d.conf
install -m 640 -o frr -g frr /dev/null /etc/frr/isisd.conf
install -m 640 -o frr -g frr /dev/null /etc/frr/ripd.conf
install -m 640 -o frr -g frr /dev/null /etc/frr/ripngd.conf
install -m 640 -o frr -g frr /dev/null /etc/frr/pimd.conf
install -m 640 -o frr -g frr /dev/null /etc/frr/ldpd.conf
install -m 640 -o frr -g frr /dev/null /etc/frr/nhrpd.conf
install -m 640 -o frr -g frrvty /dev/null /etc/frr/vtysh.conf

printf "Configuration files are created"
printf "\n"
printf "Install completed, creating the configuration files in /etc/frr/*"
printf "\n"
printf "\n"
printf "Finally un comment the following lines in /etc/sysctl.conf to enable Ipv4 and Ipv6 forwarding"
printf "\n"
# uncomment out the following lines in /etc/sysctl.conf
printf "
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
"
printf "\n"
printf "Then reboot or use sysctl -p to apply the same config to the running system"
printf "\n"
printf "\n"
printf "Adding library directory to /etc/ld.so.conf to avoid issue with not finding shared libraries"
#adding this directory to avoid the error below, when trying to start zebra:
# ./zebra: error while loading shared libraries: libfrr.so.0: cannot open shared object file: No such file or directory
echo include /usr/lib/frr >> /etc/ld.so.conf
ldconfig
printf "\n"
printf "\n"
printf "\n"
printf "
Frr is installed to the following directories\n:
===============================================
Example dir:                        /usr/share/doc/frr/examples
Local State Directory dir:          /var/run/frr
System binaries dir:                /usr/lib/frr
System configuration dir:           /etc/frr
"
printf "\n"
