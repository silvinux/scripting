#!/bin/bash

echo "You have $# parameter"

for i in "$@ "
do
	echo $i
done
exit
