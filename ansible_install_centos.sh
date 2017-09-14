printf "== Installing Ansible for Centos7 (run as root user) =="
printf "\n"
printf "== Adding EPEL repo =="
yum -y install epel-release
# change https to http update
sed -i "s/mirrorlist=https/mirrorlist=http/" /etc/yum.repos.d/epel.repo
printf "== Updating repos =="
yum -y update
printf "== Installing Ansible =="
yum -y install ansible
