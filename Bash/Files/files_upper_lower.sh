#############################################################################
## Copyleft (.) Mar 2016                                                   ##
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
#!/bin/bash
#DIRECTORY=test
LOWER=0
UPPER=0

usage(){
echo "Option -$OPTARG needs an argument." >&2
echo "Usage: -d directory | -u upper | -l lower"
exit 1
}

#No arguments
if [ $# -eq 0 ];
then
        usage
fi

while getopts ":d:*:ulh" option; do
    case $option in
        d)
                DIRECTORY=$OPTARG
                ;;
        u)
                UPPER=1
                ;;
        l)
                LOWER=1
                ;;
        h)
                usage
                ;;
        \?)
                echo "Invalid option: -$OPTARG" >&2
                exit 1
                ;;
        :)
                echo "Option -$OPTARG requires an argument." >&2
                exit 1
                ;;

        esac
done
if [[ -z $DIRECTORY ]];then
        echo "Option -$OPTARG requires -d (directory)."
elif [[ -d $DIRECTORY ]];then
        if [[ $UPPER -eq 0 ]] && [[ $LOWER -eq 0 ]];then
                echo "Option -$OPTARG requires an argument -u (upper) or -l (lower)."
        elif [[ $UPPER -eq 1 ]] && [[ $LOWER -eq 0 ]];then
                echo "======================================"
                echo "UPPERCASE  || DIR: $DIRECTORY"
                echo "======================================"
                for file in $(ls $DIRECTORY);
                do
                        if [[ "$DIRECTORY/$file" != "$DIRECTORY/${file^^}" ]];then
                                mv -- "$DIRECTORY/$file" "$DIRECTORY/${file^^}"
                        fi
                done
                ls $DIRECTORY| head
        elif [[ $LOWER -eq 1 ]] && [[ $UPPER -eq 0 ]] ;then
                echo "======================================"
                echo "LOWERCASE || DIR: $DIRECTORY"
                echo "======================================"
                for file in $(ls $DIRECTORY);
                do
                        if [[ "$DIRECTORY/$file" != "$DIRECTORY/${file,,}" ]];then
                                mv -- "$DIRECTORY/$file" "$DIRECTORY/${file,,}"
                        fi
                done
                ls $DIRECTORY| head
        fi
else
        echo "NOT a directory"
fi

