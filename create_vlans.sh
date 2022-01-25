parent_int=eno1
for i in $(seq 23 30); 
    # create vlan, disable IPv4/IPv6 and bounce the interface
    do nmcli connection add type vlan con-name vlan$i ifname vlan$i vlan.parent $parent_int vlan.id $i
    nmcli connection modify vlan$i ipv4.method disabled
    nmcli connection modify vlan$i ipv6.method disabled
    nmcli connection down vlan$i
    nmcli connection up vlan$i 
done