#!/bin/bash
#
# basic bash script to clone and install frr for debian 8 systems
# To Do list:
# - check if cnofiguration files exist and dont re create if they already exist
#
#
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

apt-get update && apt-get install git autoconf automake libtool make gawk libreadline-dev texinfo libjson-c-dev pkg-config bison flex python-pip libc-ares-dev python3-dev -y

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
if [ -d "$current_dir/frr" ];
    then
        printf "\n"
        printf "!! -*- The directoy $current_dir/frr already exists!! -*- !!\n"
        printf "\n"
        #stop_and_wait 'If you continue this directory WILL BE DELETED, press ENTER to continue or CTRIL + C to abort...'
        printf "\nDeleting $current_dir/frr\n"
        rm -rf $current_dir/frr
        printf "Cloning free range routing (frr) repo into the following directory:\n"
        printf "$current_dir/frr\n"
        git clone https://github.com/frrouting/frr.git frr
    else
        printf "Cloning frrouting (frr) repo into the following directory:\n"
        printf "$current_dir/frr\n"
        git clone https://github.com/frrouting/frr.git frr
fi
printf "\n"
#stop_and_wait 'Starting frr installation, press ENTER to continue or CTRL + C to abort...'
printf "\n"
# start the frr install
cd $current_dir/frr
./bootstrap.sh
printf "\n"
printf "building frrouting with all the default options"
printf "\n"
# configure
cd $current_dir/frr
./configure \
    --enable-exampledir=/usr/share/doc/frr/examples/ \
    --localstatedir=/var/opt/frr \
    --sbindir=/usr/lib/frr \
    --sysconfdir=/etc/frr \
    --enable-vtysh \
    --enable-isisd \
    --enable-pimd \
    --enable-watchfrr \
    --enable-ospfclient=yes \
    --enable-ospfapi=yes \
    --enable-multipath=64 \
    --enable-user=frr \
    --enable-group=frr \
    --enable-vty-group=frrvty \
    --enable-configfile-mask=0640 \
    --enable-logfile-mask=0640 \
    --enable-rtadv \
    --enable-tcp-zebra \
    --enable-fpm \
    --enable-ldpd \
    --with-pkg-git-version \
    --with-pkg-extra-version=-MyOwnFRRVersion

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
printf "Creating the configuration files in /etc/frr/\n"
printf "==============================================="
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

printf "Configuration files created"
printf "\n"
printf "\n"

printf "\n"
printf "Populating example configurations for testing purposes"
printf "======================================================"
printf "\n"
printf "\n"
cp /usr/share/doc/frr/examples/zebra.conf.sample /etc/frr/zebra.conf
cp /usr/share/doc/frr/examples/vtysh.conf.sample /etc/frr/vtysh.conf
cp /usr/share/doc/frr/examples/ripngd.conf.sample /etc/frr/ripngd.conf
cp /usr/share/doc/frr/examples/ripd.conf.sample /etc/frr/ripd.conf
cp /usr/share/doc/frr/examples/pimd.conf.sample /etc/frr/pimd.conf
cp /usr/share/doc/frr/examples/ospfd.conf.sample /etc/frr/ospfd.conf
cp /usr/share/doc/frr/examples/ospf6d.conf.sample /etc/frr/ospf6dd.conf
cp /usr/share/doc/frr/examples/ldpd.conf.sample /etc/frr/ldpd.conf
cp /usr/share/doc/frr/examples/isisd.conf.sample /etc/frr/isisd.conf
cp /usr/share/doc/frr/examples/eigrpd.conf.sample /etc/frr/eigrpd.conf
cp /usr/share/doc/frr/examples/bgpd.conf.sample /etc/frr/bgpd.conf

if grep -q '#net.ipv4.ip_forward=1' "/etc/sysctl.conf"; then
    sed -i -e 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
    sysctl -p
    printf "IPv4 forwarding is now enabled in /etc/sysctl.conf and loaded on the system\n"
else
    printf "IPv4 forwarding is already enabled in /etc/sysctl.conf\n"
fi

if grep -q '#net.ipv6.conf.all.forwarding=1' "/etc/sysctl.conf"; then
    sed -i -e 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/g' /etc/sysctl.conf
    sysctl -p
    printf "IPv6 forwarding is now enabled in /etc/sysctl.conf and loaded on the system\n"
else
    printf "IPv6 forwarding is already enabled in /etc/sysctl.conf\n"
fi
printf "
Creating the local state directory and setting correct permissions:\n
=====================================================================
"
mkdir /var/opt/frr
chown frr /var/opt/frr

printf "\n"
printf "local state directory created at /var/opt/frr owner set to frr user."
printf "\n"
printf "\n"
printf "\n"
printf "Checking if library directory exists in /etc/ld.so.conf to avoid
issue with not finding shared libraries, directory will be added if it is not
already present."
#adding this directory to avoid the error below, when trying to start zebra:
# ./zebra: error while loading shared libraries: libfrr.so.0: cannot open shared object file: No such file or directory
#back function to check if the library will be loaded on boot and add it if not
if grep -xq "include /usr/local/lib" /etc/ld.so.conf;
    then
        printf "/usr/local/lib directory already exists in /etc/ld.so.conf"
    else
        echo include /usr/local/lib >> /etc/ld.so.conf
        printf "\n\nAdded the follwing line to /etc/ld.so.conf file:\n
        include /usr/local/lib"
fi
# reload the /etc/ld.so.conf file
ldconfig
printf "\n"
printf "\n"
printf "\n"
printf "
Frr is installed to the following directories:\n
===============================================
Example dir:                        /usr/share/doc/frr/examples
Local State Directory dir:          /var/opt/frr
System binaries dir:                /usr/lib/frr
System configuration dir:           /etc/frr
"
printf "\n"

printf "
Starting all frr daemons:\n
========================"
/usr/lib/frr/./zebra -d
/usr/lib/frr/./isisd -d
/usr/lib/frr/./bgpd -d
/usr/lib/frr/./ospfd -d
/usr/lib/frr/./ospf6d -d
/usr/lib/frr/./frr -d
/usr/lib/frr/./pimd -d
/usr/lib/frr/./ripngd -d
/usr/lib/frr/./ripd -d
/usr/lib/frr/./nhrpd -d
/usr/lib/frr/./ldpd -d
