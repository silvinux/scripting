#!/bin/bash

if [[ -f $1 ]];then
	echo "$1 is a file"
elif [[ -d $1  ]];then
	echo "$1 is a directory"
elif [[ -b $1 ]];then
	echo "$1 is a block device"
else 
	echo "I dont know what $1 is"
fi
