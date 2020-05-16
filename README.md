# flink_on_k8s
I have done small POC of running flink session cluster o K8S using dockerfile

Here, I have performed following steps:

  1. tried to create "DockerfileJob" for JobManager  which uses "docker-entrypoint-job.sh" to run jobmanager.sh and flink job via command  
      line .Then this image I have is "flink_task:v1" using this command 
      
      
         $ docker image build --file DockerfileJob --tag flink_job:v1 .

  2. I created "DockerfileTask" for TaskManager which run taskmanager.sh and image is "flink_task:v1"

  3. Now, I used flink_job:v1 image inside "jobmanager-deployment.yaml" which uses "docker-entrypoint-task.sh" and creates pod for 
     JobManager with required ports and volume mount

  4. Use flink_task:v1 image inside "taskmanager-deployment.yaml" and gave replica = 2, to create 2 pods for TaskManager
  
  5. I also created "flink-configuration-configmap.yaml" which creare configuration files like 
        1. log4j.properties
        2. log4j-cli.properties ( usefule to add this configuration when we are running flink job on command line)
        3. flink-conf.yaml for heap size, rpc port,task slots realted details
        
  6. File "jobmanager-service.yaml" which create Service that exposes rpc and UI port for jobmanager  
  
  7. In my POC, I was using Docker-Desktop running on my mac machine
  
  8. Then ran commands to create pods 
      $  kubectl create -f jobmanager-service.yaml
      
      $ kubectl get service
      
          NAME               TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
        
          flink-jobmanager   ClusterIP   10.10x.xx.96   <none>        6123/TCP,6124/TCP,8081/TCP   17s
  
      $  kubectl create -f jobmanager-deployment.yaml
      
          deployment.extensions/flink-jobmanager created
        
      $ kubectl create -f taskmanager-deployment.yaml
      
          deployment.extensions/flink-taskmanager created
        
      $ kubectl get pod
      
            NAME                                READY        STATUS        RESTARTS         AGE

            flink-jobmanager-6b8fc8dc9b-lzfr5   1/1          Running             0          72s

            flink-taskmanager-86c87cb4b-b6ld4   0/1          ContainerCreating   0          68s

            flink-taskmanager-86c87cb4b-bncb4   0/1          ContainerCreating   0          68s
        
  9. Then I did port forwarding to view results in Flink UI which runs on 8081, hence I used job-manager-pod as we got above
      
          $ kubectl port-forward flink-jobmanager-6b8fc8dc9b-lzfr5 8083:8081 
          
       -> as 8081 port of localhost was already in use , I used 8083
      
     
     Then on my browser, I did localhost:8083 and boom !!!!
      
      
 10. Some commands I found useful
 
         $ kubectl exec flink-jobmanager-6b8fc8dc9b-lzfr5 -it /bin/bash -> to look inside pod
      
          $  kubectl describe pod flink-jobmanager-6b8fc8dc9b-lzfr5
     
         $ docker container run --name flinkcontainer1  -p 8085:8081 -p 6125:6123 flink_job:v1 
         $ docker images --no-trunc --format '{{.ID}} {{.CreatedSince}}' //Remove docker images since x time
         $







