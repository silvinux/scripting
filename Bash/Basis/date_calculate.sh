# date --date="2016-05-21 13:49:00" +%s
#1463831340
# date --date="2016-05-21 15:16:49:00" +%s
#date: invalid date ‘2016-05-21 15:16:49:00’
# date --date="2016-05-21 15:16:00" +%s
#1463836560
#!/bin/bash
START=$(date --date="2016-05-21 13:49:00" +%s)
# do something
# start your script work here
ls -R /etc > /tmp/x
rm -f /tmp/x
# your logic ends here
END=$(date --date="2016-05-21 15:16:00" +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"



