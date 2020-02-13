#!/bin/sh

JOB_MANAGER_RPC_ADDRESS=${JOB_MANAGER_RPC_ADDRESS:-$(hostname -f)}

sed -i -e "s/jobmanager.rpc.address: localhost/jobmanager.rpc.address: ${JOB_MANAGER_RPC_ADDRESS}/g" $FLINK_HOME/conf/flink-conf.yaml
sed -i -e "s/taskmanager.numberOfTaskSlots: 1/taskmanager.numberOfTaskSlots: $(grep -c ^processor /proc/cpuinfo)/g" $FLINK_HOME/conf/flink-conf.yaml

echo "Starting Task Manager"
nohup $FLINK_HOME/bin/taskmanager.sh &

sleep 5m

echo "Submit flink job in background by task manager" > /opt/flink/input/echo.txt