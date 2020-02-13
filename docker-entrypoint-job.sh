#!/bin/sh

JOB_MANAGER_RPC_ADDRESS=${JOB_MANAGER_RPC_ADDRESS:-$(hostname -f)}

echo "Starting Job Manager" > /opt/flink/input/echo.txt
echo $(whoami) >> /opt/flink/input/echo.txt
sed -i -e "s/jobmanager.rpc.address: localhost/jobmanager.rpc.address: ${JOB_MANAGER_RPC_ADDRESS}/g" $FLINK_HOME/conf/flink-conf.yaml



nohup $FLINK_HOME/bin/jobmanager.sh &

sleep 5m 
 
echo "Submit flink job in background by job manager" >> /opt/flink/input/echo.txt
#nohup   /submit-flink-job.sh &

nohup flink run /opt/flink/lib/flink-basic-example-1.0.jar --input /opt/flink/input/input.txt --output /opt/flink/input/output.txt > /opt/flink/input/app.out &
