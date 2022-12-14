#If ClickHouse server has running queries that takes more than 1 second, it returns an warning email.
#linkedin : https://www.linkedin.com/in/can-sayın-b332a157/
#cansayin.com

#!/bin/bash
 
cd /home/clickhouse
clickhouse-client -q "SELECT * FROM system.processes where elapsed > 1 order by elapsed desc " >> clickhouseLongRunningQueriesAlert.txt
 
cd /home/clickhouse
host = hostname
usep= cat clickhouseLongRunningQueriesAlert.txt
if [ "${usep}" -gt 1 ]; then
echo "There are long running queries on $host" > /tmp/clickhouseLongRunningQueriesAlert.out

 
tomail='can.sayn@mail.com'
frommail='can.sayn@mail.com'
smtpmail=smtp.chistadata.com
echo "There are long running queries on $host"  | /bin/mailx -s "$host Clickhouse Query Error" -r  "$frommail" -S smtp="$smtpmail" $tomail < /tmp/clickhouseLongRunningQueriesAlert.out
 
fi
 
cd /home/clickhouse
rm -rf clickhouseLongRunningQueriesAlert.txt
