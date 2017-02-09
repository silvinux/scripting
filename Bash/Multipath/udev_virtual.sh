#!/bin/bash
echo "Etiqueta, followed by [ENTER]:"
read etiqueta
echo "Lista, followed by [ENTER]:"
read lista
echo "Inicio Contador, followed by [ENTER]:"
read CONTADOR
for i in $(cat $lista)
do
        if [ $CONTADOR -le "9" ];then
                echo "KERNEL=="\""sd*"\"", PROGRAM=="\""scsi_id --page=0x83 --whitelisted --device=/dev/%k"\"", RESULT=="\""$i"\"", SYMLINK="\""asmdisk_udev/${etiqueta}00${CONTADOR}"\"", OWNER="\""orainfra"\"", GROUP="\""asmadmin"\"", MODE="\""0660"\"" "
        else
                echo KERNEL=="\""sd*"\"", PROGRAM=="\""scsi_id --page=0x83 --whitelisted --device=/dev/%k"\"", RESULT=="\""$i"\"", SYMLINK="\""asmdisk_udev/${etiqueta}0${CONTADOR}"\"", OWNER="\""orainfra"\"", GROUP="\""asmadmin"\"", MODE="\""0660"\""
        fi
        let CONTADOR++
done
