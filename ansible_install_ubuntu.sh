printf "Installing Ansible for Debian (run as root user)"
printf "\n"
printf "Adding Ubuntu PPA to /etc/apt/sources.list"
echo deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main >> /etc/apt/sources.list
printf "Adding keyserver.ubuntu.com"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C36 -y
apt-get update
apt-get upgrade -y --force-yes
printf "Installing ansible and prerequisites"
apt-get install ansible -y --force-yes
