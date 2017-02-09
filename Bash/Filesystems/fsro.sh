#############################################################################
## Copyleft (.) Jul 2015                                                   ##
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
#COMANDOS
AWK=/usr/bin/awk
SSH=/usr/bin/ssh
WC=/usr/bin/wc
CAT=/bin/cat
HOST=/usr/bin/host
PING=/bin/ping
GREP=/bin/grep
PRINTF=/usr/bin/printf
TEE=/usr/bin/tee

#PARAMETERS
SSHPAR=" -tqoPasswordAuthentication=no -o StrictHostKeyChecking=no"

LOGFILE="fsro_server_list_$(date "+%Y%m%d").txt"

#COLORS
BLACK=$(tput setaf 0)
RED=$(tput setaf 01)
GREEN=$(tput setaf 02)
YELLOW=$(tput setaf 03)
BLUE=$(tput setaf 04)
MAGENTA=$(tput setaf 05)
CYAN=$(tput setaf 06)
WHITE=$(tput setaf 07)
NC='\033[0m' # No Color

#TEXT MODES
BOLD=$(tput bold)    # Select bold mode
DIM=$(tput dim)     # Select dim (half-bright) mode
SMUL=$(tput smul)    # Enable underline mode
RMUL=$(tput rmul)    # Disable underline mode
REV=$(tput rev)     # Turn on reverse video mode
SMSO=$(tput smso)    # Enter standout (bold) mode
RMSO=$(tput rmso)    # Exit standout mode

#FUNCIONES
function usage()
{
$PRINTF "******************************\n"
$PRINTF "**TOOL for check fs remotely**\n"
$PRINTF "******************************\n"
$PRINTF "Usage: $0 [-s <hostname>] [-f </absolute/path/list/servers>]\n\n" 1>&2; exit 1;
}

Services_Status()
{
PINGSTATUS=$($PING -c 1 -s 1 -W 1 $SERVER &> /dev/null;echo $?)
SSHSTATUS=$($SSH $SSHPAR $SERVER exit;echo $?)
}

Check_Conectivity()
{
if [[ PINGSTATUS -ne 0 ]];then
        if [[ PINGSTATUS -eq 2 ]];then
                CON=$($PRINTF "Server:"${BOLD}$SERVER":${YELLOW} UNKNOWN_HOST, please CHECK!!!${NC}\n")
                OUT=10
        else
                CON=$($PRINTF "Server:"${BOLD}$SERVER":${RED}is DOWN_or_does not respond to ping, please CHECK!!!${NC}\n")
                OUT=11
        fi
elif [[ PINGSTATUS -eq 0 ]] && [[ SSHSTATUS -ne 0 ]]; then
        CON=$($PRINTF "Server:"${BOLD}$SERVERS":${GREEN}is_UP_reponse to ping, ${BOLD}${CYAN}!!!but SSH Connection has been refused!!!${NC}\n")
        OUT=12
elif [[ PINGSTATUS -eq 0 ]] && [[ SSHSTATUS -eq 0 ]]; then
        CON=$($PRINTF "Server:"${BOLD}$SERVERS":${GREEN}is_UP_and SSH is working${NC}\n")
        OUT=13
fi
}

Check_Fs()
{
ROCOUNTER=$($SSH $SSHPAR $SERVER $CAT /proc/mounts|$AWK -F' |,' '{if ($4 == "ro")print $2,$4}'|$WC -l)
ROFS=$($SSH $SSHPAR $SERVER $CAT /proc/mounts|$AWK -F' |,' '{if ($4 == "ro")print $2,$4}')
RWFS=$($SSH $SSHPAR $SERVER $CAT /proc/mounts|$AWK -F' |,' '{if ($4 == "rw")print $2,$4}')
}

Print_Results()
{
if [[ $ROCOUNTER -ge "1" ]]; then
        printf "****************************************************************\n" | $TEE -ia $LOGFILE
        printf "\t**"${BOLD}${RED}"There is/are filesystem(s) in "${RED}RO${NC}"**\n"| $TEE -ia $LOGFILE
        printf "**Server:"${BOLD}${RED}$SERVER:${NC}", RO Please Check**\n" | $TEE -ia $LOGFILE
        printf "\t${BOLD}${SMUL}${RED}$ROFS${NC}\n" | $TEE -ia $LOGFILE
        printf "****************************************************************\n" | $TEE -ia $LOGFILE
else
        printf "****************************************************************\n" | $TEE -ia $LOGFILE
        printf "\t**"${BOLD}${GREEN}"All FS in Read-Write"${NC}"**\n" | $TEE -ia $LOGFILE
        printf "**Server:"${BOLD}${GREEN}$SERVER:${NC}", You're OK**\n" | $TEE -ia $LOGFILE
        printf "****************************************************************\n" | $TEE -ia $LOGFILE
fi
}

Print_Conectivity()
{
        printf "****************************************************************\n" | $TEE -ia $LOGFILE
        printf "\t**"${BOLD}${MAGENTA}"Conectivity ISSUE"${NC}", Please Check**\n" | $TEE -ia $LOGFILE
        echo $CON       | $TEE -ia $LOGFILE
        printf "****************************************************************\n" | $TEE -ia $LOGFILE
}

#No arguments
if [ $# -eq 0 ];
then
    echo ""
    echo "Option -$OPTARG needs an argument." >&2
    echo ""
    exit 1
fi


while getopts ":s:f:*:" option; do
    case $option in
        s)
                SERVER=$OPTARG
                Services_Status
                Check_Conectivity

                if [[ OUT -ne 13 ]];then
                        Print_Conectivity
                else
                        Check_Fs
                        Print_Results
                fi
                ;;
        f)
                for SERVER in $($CAT $OPTARG);
                do
                        Services_Status
                        Check_Conectivity

                        if [[ OUT -ne 13 ]];then
                                Print_Conectivity
                        else
                                Check_Fs
                                Print_Results
                        fi
                done
                ;;
        *)
                printf "\n"
                echo "Invalid option"
                echo "Just -s and -f flag."
                printf "\n"
                echo "Usage: fsro [-s <hostname>] [-f </absolute/path/list/servers>]"
                printf "\n"
                ;;

        esac
done
