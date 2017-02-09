#!/bin/bash
#RHCE - video 164

case "$1" in
	start)
		echo "Start"
		;;
	stop)
		echo "Stop"
		;;
	restart)
		echo "restart"
		;;
	reload)
		echo "reload"
		;;
	status)
		echo "status"
		;;
	*)
		echo "Usage: $0 |start|stop|restart|reload|status"
esac
