#!/bin/bash
for i in $(lsblk -l | awk '{print $1}'| egrep -v 'NAME|sr0|lv|1|2');do a=`/lib/udev/scsi_id --page=0x83 --whitelisted --device=/dev/$i`;echo "Disco $i --- $a";done

