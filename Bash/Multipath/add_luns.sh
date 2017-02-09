#!/bin/bash
if [[ $# -eq 0 ]];then
	echo "USAGE: -a file.txt"
elif [[ $# -eq 1 ]] && [[ $1 != "-a" ]];then
	echo "Pick a valid option"
elif [[ $# -eq 2 ]] && [[ ! -f $2 ]];then
	echo "Must be a file"
else
while getopts ":a:" option;do
case $option in
	a)
		echo "Option a"
		awk '{print "\nmultipath {\n\twwn\t" $1, "\n\talias\t" $2"\n}"}' $2
		;;
	\?)
		echo "Invalid option"
		exit 1
		;;
	:)
		echo "Requires an argument"
		exit 1
		;;
	h|*)
		echo "USAGE: -a file.txt"
		exit 1
		;;
esac
done
fi

