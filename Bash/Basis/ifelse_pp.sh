#!/bin/bash
if [ `id -u` -eq 0 ]; then
for i in "$#"
do
	if [[ $i -eq 0 ]];then
		echo "Necesitas un servidor"
	elif [[  $i -eq 1 ]];then
		ssh $1 -l gnfux -t "sudo su -; bash"
	else
		echo "Solo un servidor"
	fi
done
fi
exit 0
