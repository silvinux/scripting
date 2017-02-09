#!/bin/bash

if [[ -z $1 ]];then
	echo "enter a name"
	read NAME
else
	NAME=$1
fi

echo You have entered the text $NAME
