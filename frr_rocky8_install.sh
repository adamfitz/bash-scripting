# repo/rpm instructions taken from here:
# https://rpm.frrouting.org/

echo "== Installing FRR 8 stable =="
# frr-stable will be the latest official stable release
FRRVER="frr-stable"

echo "== Installing FRR Repo for Redhat/Centos/Rocky =="
# add RPM repository on RedHat 8
#    Note: Supported since FRR 7.3
curl -O https://rpm.frrouting.org/repo/$FRRVER-repo-1-0.el8.noarch.rpm
sudo yum install ./$FRRVER* -y

echo "== Install FRR and dependancies =="
# install FRR
sudo yum install frr frr-pythontools -y

echo "== Enabling all routing daemons =="
# enable all routing daemons in config file
sed -i 's/=no/=yes/g' /etc/frr/daemons

echo "== Enabling ipv4 and ipv6 forwarding =="
# enable ipv4 and ipv6 routing
echo "net.ipv4.conf.all.forwarding=1" >> /etc/sysctl.d/90-routing-sysctl.conf
echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.d/90-routing-sysctl.conf
sysctl -p /etc/sysctl.d/90-routing-sysctl.conf

echo "== Enable and start FRR =="
# enable and start frr
sudo systemctl enable frr
sudo systemctl start frr


echo "== Disable firewalld =="
systemctl disable firewalld
systemctl stop firewalld
