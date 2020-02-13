# flink_on_k8s
I have done small POC of running flink session cluster o K8S using dockerfile

Here, I have performed following steps:

  1. tried to create "DockerfileJob" for JobManager  which run jobmanager.sh and flink job via command line

     Then this image I have is "flink_task:v1" using this command $ docker image build --file DockerfileJob --tag flink_job:v1 

  2. I created "DockerfileTask" for TaskManager which run taskmanager.sh and image is "flink_task:v1"

  3. Now, I used flink_job:v1 image inside "jobmanager-deployment.yaml" which creates pod for JobManager with required ports and volume    
      mount

  4. Use flink_task:v1 image inside "taskmanager-deployment.yaml"




