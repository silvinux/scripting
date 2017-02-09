#!/bin/bash

for i in "$#"
do
	if [[ $i -eq 0 ]];then
		echo "Zero"
	elif [[  $i -eq 1 ]];then
		echo "One"
	else
		echo "Several"
	fi
done
exit 0
