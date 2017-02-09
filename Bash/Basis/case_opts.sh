#!/bin/bash
if [[ $# -eq 0 ]];then
	echo "USAGE: -a|-b"
else
while getopts ":a:b:" option;do
case $option in
	a)
		echo "Option a"
		;;
	b)
		echo "Option b"
		;;
	\?)
		echo "Invalid option"
		exit 1
		;;
	:)
		echo "Requires an argument"
		exit 1
		;;
esac
done
fi
