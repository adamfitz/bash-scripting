#!/bin/bash

# get vlan name and number
interface_name=$1
vlan_number=$2

# vlan number must be an integer less than or equal to 4096
if [[ $vlan_number =~ ^[+-]?[0-9]+$ ]] && [[ $vlan_number -le 4096 ]]; then
    printf "\nCreating the ovs port (${interface_name}_Vlan${vlan_number}-port) as child of parent bridge0...\n"
    nmcli conn add type ovs-port conn.interface ${interface_name}_Vlan${vlan_number} master bridge0 ovs-port.tag $vlan_number con-name ${interface_name}_Vlan${vlan_number}-port


    printf "\nCreating the ovs interface (${interface_name}_Vlan${vlan_number}-ovs-int) as child of ovs port (${interface_name}_Vlan${vlan_number}-port)...\n"
    nmcli conn add type ovs-interface slave-type ovs-port conn.interface ${interface_name}_Vlan${vlan_number} master ${interface_name}_Vlan${vlan_number}-port con-name ${interface_name}_Vlan${vlan_number}-ovs-int

    printf "\nSummary:\n"
    nmcli conn show| grep "${interface_name}_Vlan${vlan_number}-port\|${interface_name}_Vlan${vlan_number}-ovs-int"
    printf "\n"

else
    printf "Script execution MUST contain the following arguments:\n$ ./create_interface.sh \$interface_name \$vlan_number\n\nNOTE: vlan number MUST be less than 4096\n"
fi

# NOTE: nmcli kind of sucks for managing interfaces, if possible just move to using ovs-vsctl intead (if possible)