# bash-scripting
Some basic shell scripts I sometimes find useful

- subnetCheck.sh - do a reverse lookup on all Ipv4 addresses in a /24 netblock

- tap_interfaces_gns3.sh - create multiple tap interfaces and add them to a bridge to connect devices in gns3 to local network

- install_frr_deb8.sh - script to install and configure frrouting (from git repo) on debian 8

- ansible_install_ubuntu.sh - installs ansible from Ubuntu PPA (works with ubuntu/debian)

- ansible_install_centos.sh - install ansible from EPEL repo (CentOS7)

- dir_clean.sh - bulk delete a list of directories from a file

- samba_install.sh - script to install and configure basic authenticated samba share on Centos7

- install_frr_centos7.sh - installs and configure frrouting (from git repo)

- move_dir_contents.sh - scritp takes a list of directories from a file and moves them to the root of teh target directory

- update_lang.sh - read list of mkv files in directory and use ffmpeg to write a new output file with the default audio language set to english  

- create_vlans.sh - create a number of vlans attached to physical parent interface linux

- create_interfaces.sh - create ovs interface/port for vm (using nmcli)

- bash_config - some useful bsh profile configuration

- frr_rocky8_install.sh - script installs latest stable frr on Rocky Linux 8

- update_nnslackbot.sh - script to backup the local install, load keys, clone repo and restart the systemd service.  Script is primarily for cloning new code to the current running instance.