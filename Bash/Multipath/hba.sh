#############################################################################
## Copyleft (.) Jul 2015                                                   ##
## silvinux7@gmail.com                                                     ##
#############################################################################
## This program is free software; you can redistribute it and/or modify    ##
## it under the terms of the GNU General Public License as published by    ##
## the Free Software Foundation; either version 3 of the License, or       ##
## (at your option) any later version.                                     ##
##                                                                         ##
## This program is distributed in the hope that it will be useful,         ##
## but WITHOUT ANY WARRANTY; without even the implied warranty of          ##
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           ##
## GNU General Public License for more details.                            ##
#############################################################################
#!/bin/sh
#
check_hba(){
HBADEV=$(/sbin/lspci | grep -i fibre | wc -l)
VIRTUAL=$( /usr/sbin/dmidecode -s system-product-name | egrep -ci 'vmware|kvm' )
HBA=0

if [[ $VIRTUAL -eq 1 ]];then
	echo "No Tiene HBA - Virtual Machine"
elif [[ $HBADEV -gt 0 ]];then
        if [[ -d /sys/class/fc_host ]];then
                HBAS=$(ls /sys/class/fc_host)
		printf "HBA\tNode_Name\t\tPort_Name\t\tFabric_Name\t\tState\t\tSpeed\t\n"
		for HBA in $HBAS;do
		node=$(cat /sys/class/fc_host/$HBA/node_name)
		port=$(cat /sys/class/fc_host/$HBA/port_name)
		state=$(cat /sys/class/fc_host/$HBA/port_state)
		fabric=$(cat /sys/class/fc_host/$HBA/fabric_name)
		speed=$(cat /sys/class/fc_host/$HBA/speed)
		printf $HBA"\t"$node"\t"$port"\t"$fabric"\t"$state"\t\t"$speed"\t"
		printf "\n"
		done
		echo
        elif [[ -d /proc/scsi/qla2xxx/ ]];then
                HBAS=$(ls /proc/scsi/qla2xxx/)
                printf "HBA\tNode_Name\t\tPort_Name\t\tState\t\n"
		for HBA in $HBAS;do
		node=$(grep adapter-node /proc/scsi/qla2xxx/$HBA | awk -F'=' '{print $2}')
		port=$(grep adapter-port /proc/scsi/qla2xxx/$HBA | awk -F'=' '{print $2}')
		state=$(grep -i "loop state" /proc/scsi/qla2xxx/$HBA | awk '{print $5}')
		printf $HBA"\t"$node"\t"$port"\t"$state"\t\t"
		printf "\n"
		done
		echo

        else
                echo "No Tiene HBA"
        fi
fi
}

check_hba
