# apigee-hyrbid-templates

This project allows you to install apigee hybid runtime in Google Cloud Platform using GCP's deployment manager.

This template will do following
- Create kubernets clusters
- Create service accounts and assign right roles
- Install hybrid runtime
- Post install setup like adding synchronizer service account and mart end points.

## Prerequisite

### gcloud
- Install gcloud sdk from https://cloud.google.com/sdk/downloads
- Initialize your account
- Set gcloud to your gcp project
```
  gcloud config set project <project-id>
```
- You need to have owner or Editor role to run deployment manager templates.

## Getting Started
- Keep following Key/Certificate pair in config/ directory

ingress-server.key - The private key for ingress 
ingress-server.pem - The public key for ingress
mart-server.key - The private key for mart
mart-server.pem - The public key for mart


- Make  changes in apigee-cluster.yaml file. 

The apigee section of properties is the override.yaml. Change hostAliases and loadbalancers as you wish. my_project_id, my_cluster_name and my_cluster_region are special key words. They will be populated from the value you define in k8_cluster section.The gcp project is your home project your run this.

- Toggle true/false in connect_agent if using apigee connect or direct mart address.
- Toggle true/false in deleteAfterSetup if you want the jump host to be deleted after setup.
- This setup also assumes that for each environment you use the same synchronizer key.

```
imports:
- path: config/ingress-server.key
  name: ingress-server.key
- path: config/ingress-server.pem
  name: ingress-server.pem
- path: config/mart-server.key
  name: mart-server.key
- path: config/mart-server.pem
  name: mart-server.pem

jump_host:
  instanceType: n1-standard-2
  location: us-east1
  zone: us-east1-b
  diskSizeGb: 30
  imageType: https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/family/debian-9
  deleteAfterSetup: false 
k8s_cluster:
  name: apigee-hybrid
  location: us-east1
  zone: us-east1-b
  initialNodeCount: 3
  instanceType: n1-standard-4
  diskSizeGb: 30
  autoscaling: false
  autoUpgrade: false
  autoRepair: false
  imageType: COS
apigee:
  gcp:
    projectID: my_project_id
  # Apigee org name.
  org: my_project_id
  # Kubernetes cluster name details
  k8sCluster:
    name: my_cluster_name
    region: "my_cluster_region"
  # Apigee org name.
  virtualhosts:
  - name: test
    hostAliases: 
      - "my_project_id-test.hybrid-apigee.net"
    sslCertPath: ingress-server.pem
    sslKeyPath: ingress-server.key
    routingRules:
      - env : test
  - name: prod
    hostAliases: 
      - "my_project_id-prod.hybrid-apigee.net"
    sslCertPath: ingress-server.pem
    sslKeyPath: ingress-server.key
    routingRules:
      - env : prod
  envs:
      # Apigee environment name.
    - name: test
      serviceAccountPaths:
        synchronizer: ./service-accounts/my_project_id-synchronizer-apigee.json
        udca: ./service-accounts/my_project_id-udca-apigee.json
    - name: prod
      serviceAccountPaths:
        synchronizer: ./service-accounts/my_project_id-synchronizer-apigee.json
        udca: ./service-accounts/my_project_id-udca-apigee.json
  cassandra:
    replicaCount : 3
  mart:
    hostAlias: "my_project_id-mart.hybrid-apigee.net"
    serviceAccountPath: ./service-accounts/my_project_id-mart-apigee.json
    sslCertPath: mart-server.pem
    sslKeyPath:  mart-server.key
  metrics:
    serviceAccountPath: ./service-accounts/my_project_id-metrics-apigee.json
  # Apigee Connect Agent
  connectAgent:
    enabled: false
    serviceAccountPath: ./service-accounts/my_project_id-connect-apigee.json
  ingress:
    enableAccesslog: true
    runtime:
      loadBalancerIP: 35.196.24.106
    mart:
      loadBalancerIP: 35.185.43.207 

```

-  To enable the external load balancer, you can configure the ingress section and add mart and runtime load balancer. 

- Deploy to GCP

    ```
    ./deploy.sh "RESOURCE_NAME"
    ```
    RESOURCE_NAME is the name you give to your deployments. All the GCP resources will be tagged under that RESOURCE. All the GCP resources are created with name  having prefix of "RESOURCE_NAME".
    e.g :

```sh
 /deploy.sh raj
The fingerprint of the deployment is 8FaDn2YGgCmgZxD-Pi71hA==
Waiting for create [operation-1580453349299-59d69f87816d3-f0db1571-d413777d]...done.
Create operation operation-1580453349299-59d69f87816d3-f0db1571-d413777d completed successfully.
NAME                       TYPE                                                                          STATE      ERRORS  INTENT
apigee-hybrid              container.v1.cluster                                                          COMPLETED  []
get-iam-policy             gcp-types/cloudresourcemanager-v1:cloudresourcemanager.projects.getIamPolicy  COMPLETED  []
patch-iam-policy           gcp-types/cloudresourcemanager-v1:cloudresourcemanager.projects.setIamPolicy  COMPLETED  []
raj-755-a-admin            iam.v1.serviceAccount     COMPLETED  []
raj-755-a-cassandra        iam.v1.serviceAccount    COMPLETED  []
raj-755-a-mart             iam.v1.serviceAccount     COMPLETED  []
raj-755-a-metrics          iam.v1.serviceAccount     COMPLETED  []
raj-755-a-synchronizer     iam.v1.serviceAccount  COMPLETED  []
raj-755-a-udca             iam.v1.serviceAccount    COMPLETED  []
raj-apigee-cluster         compute.v1.instance       COMPLETED  []
raj-apigee-cluster-config  runtimeconfig.v1beta1.config COMPLETED  []
raj-apigee-cluster-waiter  runtimeconfig.v1beta1.waiter COMPLETED  []
raj-apigee-config          runtimeconfig.v1beta1.config  COMPLETED  []
raj-apigee-id              runtimeconfig.v1beta1.variable  COMPLETED  []
```


### Enable APIS

./deploy.sh enables the required services. You can also enable them manually as follows 

- gcloud services enable container.googleapis.com
- gcloud services enable container.googleapis.com
- gcloud services enable apigee.googleapis.com
- gcloud services enable iam.googleapis.com
- gcloud services enable cloudresourcemanager.googleapis.com
- gcloud services enable runtimeconfig.googleapis.com
- gcloud services enable sourcerepo.googleapis.com
- gcloud services enable logging.googleapis.com
- gcloud services enable monitoring.googleapis.com


### IAM Roles

deploy.sh will add following roles to these service accounts

- [PROJECT-NUMBER]@cloudservices.gserviceaccount.com

```
Kubernetes Engine Admin
Kubernetes Cluster Admin

```

- [PROJECT-NUMBER]-compute@developer.gserviceaccount.com

```
Kubernetes Engine Admin
Project IAM Admin
```

## Undeploy and Clean the deployment
```sh
./clean.sh "RESOURCE_NAME"
```
This will clean up all created deployment resources including the service accounts.

e.g :
```sh
./clean.sh raj
```


## Update the deployment
```sh
./update.sh "RESOURCE_NAME"
```
e.g :
```sh
./update.sh raj
```

## Troubleshootig



## License

Apache 2.0 - See [LICENSE](LICENSE) for more information.
