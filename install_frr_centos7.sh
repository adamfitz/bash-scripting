#!/bin/bash
#
# I did not write this.
#
# Thanks to the person who shared this on the frr mailing list!
#
# I just added the sed command to start all the frr daemons (found on stackoverflow)
#
#
sudo yum install git autoconf epel-release automake libtool make gawk    readline-devel texinfo net-snmp-devel groff pkgconfig    json-c-devel pam-devel bison flex pytest c-ares-devel    perl-XML-LibXML python-devel systemd-devel -y
yum install python-pip -y
sudo pip install sphinx
sudo groupadd -g 92 frr
sudo groupadd -r -g 85 frrvt
sudo useradd -u 92 -g 92 -M -r -G frrvt -s /sbin/nologin   -c "FRR FRRouting suite" -d /var/run/frr frr
git clone https://github.com/frrouting/frr.git frr
cd frr
./bootstrap.sh
./configure     --bindir=/usr/bin     --sbindir=/usr/lib/frr     --sysconfdir=/etc/frr     --libdir=/usr/lib/frr     --libexecdir=/usr/lib/frr     --localstatedir=/var/run/frr     --with-moduledir=/usr/lib/frr/modules     --enable-pimd     --enable-snmp=agentx     --enable-multipath=64     --enable-ospfclient=yes     --enable-ospfapi=yes     --enable-user=frr     --enable-group=frr     --enable-vty-group=frrvt     --enable-rtadv     --enable-systemd     --disable-exampledir     --enable-watchfrr     --enable-cumulus     --disable-ldpd     --enable-fpm     --enable-nhrpd     --enable-eigrpd     --enable-babeld     --with-pkg-git-version     --with-pkg-extra-version=-MyOwnFRRVersion
make
make check
make install
sudo mkdir /var/log/frr
sudo mkdir /etc/frr
sudo touch /etc/frr/zebra.conf
sudo touch /etc/frr/bgpd.conf
sudo touch /etc/frr/ospfd.conf
sudo touch /etc/frr/ospf6d.conf
sudo touch /etc/frr/isisd.conf
sudo touch /etc/frr/ripd.conf
sudo touch /etc/frr/ripngd.conf
sudo touch /etc/frr/pimd.conf
sudo touch /etc/frr/nhrpd.conf
sudo touch /etc/frr/eigrpd.conf
sudo touch /etc/frr/babeld.conf
sudo chown -R frr:frr /etc/frr/
sudo touch /etc/frr/vtysh.conf
sudo chown frr:frrvt /etc/frr/vtysh.conf
sudo chmod 640 /etc/frr/*.conf
sudo install -p -m 644 redhat/daemons /etc/frr/
sudo chown frr:frr /etc/frr/daemons
echo "net.ipv4.conf.all.forwarding=1" >> /etc/sysctl.d/90-routing-sysctl.conf
echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.d/90-routing-sysctl.conf
sudo sysctl -p /etc/sysctl.d/90-routing-sysctl.conf
sudo install -p -m 644 redhat/frr.service /usr/lib/systemd/system/frr.service
sudo install -p -m 755 redhat/frr.init /usr/lib/frr/frr
sudo systemctl preset frr.service
# enabling all daemons
sed -i -e 's/zebra=no/zebra=yes/g' /etc/frr/daemons
sed -i -e 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
sed -i -e 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons
sed -i -e 's/ospf6d=no/ospf6d=yes/g' /etc/frr/daemons
sed -i -e 's/ripd=no/ripd=yes/g' /etc/frr/daemons
sed -i -e 's/ripngd=no/ripngd=yes/g' /etc/frr/daemons
sed -i -e 's/isisd=no/isisd=yes/g' /etc/frr/daemons
sed -i -e 's/ldpd=no/ldpd=yes/g' /etc/frr/daemons
sed -i -e 's/pimd=no/pimd=yes/g' /etc/frr/daemons
sed -i -e 's/nhrpd=no/nhrpd=yes/g' /etc/frr/daemons
sed -i -e 's/eigrpd=no/eigrpd=yes/g' /etc/frr/daemons
sed -i -e 's/babeld=no/babeld=yess/g' /etc/frr/daemons
sed -i -e 's/sharpd=no/sharpd=yes/g' /etc/frr/daemons
sed -i -e 's/pbrd=no/pbrd=yes/g' /etc/frr/daemon
# enable and start frr
systemctl enable frr
systemctl start frr