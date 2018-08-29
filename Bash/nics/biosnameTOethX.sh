#!/bin/bash
j=0
echo BIOS -- ETHx -- Speed
for i in $(ip ad |grep BROAD|awk '{print $2}'|cut -d':' -f1|sort|grep -v bond|cut -d':' -f1);do echo $i -- eth$j -- $(ethtool $i|grep Speed);let "j+=1";done
exit 0

