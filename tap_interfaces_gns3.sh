#
#Script to create and bring up tap interfaces for use with GNS3 
#
#Thanks to this guy for the tutorial on how to do this:
#http://myhomelab.blogspot.com.au/2011/12/add-loopbacks-in-ubuntu-for-gns3.html
#
#I just created the script to run this quick and dirty when I reboot

#create the tap interfaces
sudo tunctl -t tap0
sudo tunctl -t tap1
sudo tunctl -t tap2
sudo tunctl -t tap3
sudo tunctl -t tap4
sudo tunctl -t tap5
#remove the IP and set the interface to up
sudo ifconfig tap0 0.0.0.0 promisc up
sudo ifconfig tap1 0.0.0.0 promisc up
sudo ifconfig tap2 0.0.0.0 promisc up
sudo ifconfig tap3  0.0.0.0 promisc up
sudo ifconfig tap4 0.0.0.0 promisc up
sudo ifconfig tap5 0.0.0.0 promisc up
#add the tap interfaces to the existing linux bridge
sudo brctl addif bridge0 tap0
sudo brctl addif bridge0 tap1
sudo brctl addif bridge0 tap2
sudo brctl addif bridge0 tap3
sudo brctl addif bridge0 tap4
sudo brctl addif bridge0 tap5


