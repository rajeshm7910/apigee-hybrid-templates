# apigee-hyrbid-gcp

This project allows you to install apigee hybid runtime in Google Cloud Platform using GCP's deployment manager. 

## Prerequisite

### gcloud
- Install gcloud sdk from https://cloud.google.com/sdk/downloads
- Initialize your account

## Enable APIS

Enable Following APIS in the GCP Project

- deploymentmanager.googleapis.com
- Runtime Configuration API
- cloudresourcemanager.googleapis.com
- IAM API

## IAM Roles

- Allocate Owner following Access to default cloudservices account :

Go to IAM & Admin -> IAM from GCP Console. You will find a IAM account like 00000000@cloudservices.gserviceaccount.com
Allocate Owner access to the account


- Allocate access to default compute services accouunt -

Go to IAM & Admin -> IAM from GCP Console. You will find a IAM account like 00000000-compute@developer.gserviceaccount.com	

Allocate following roles to the account -

```
Kubernetes Engine Admin
Kubernetes Engine Cluster Admin
Editor
Project IAM Admin
```

## Apigee Hybrid 
Please go through https://docs.apigee.com/hybrid to know more about Apigee Hybrid .


## Getting Started
- Keep Key/Certificate pair in config/ directory


- Deploy to GCP

    ```
    ./deploy.sh "RESOURCE_NAME"
    ```
    RESOURCE_NAME is the name you give to your deployments. All the GCP resources will be tagged under that RESOURCE. All the GCP resources are created with name  having prefix of "RESOURCE_NAME".
    e.g :
```sh
 /deploy.sh my-hybrid
The fingerprint of the deployment is 8FaDn2YGgCmgZxD-Pi71hA==
Waiting for create [operation-1564328751326-58ebfab88e35c-6bbd8f1a-317d7e41]...done.
Create operation operation-1564328751326-58ebfab88e35c-6bbd8f1a-317d7e41 completed successfully.
NAME                             TYPE                                                                          STATE      ERRORS  INTENT
get-iam-policy    gcp-types/cloudresourcemanager-v1:cloudresourcemanager.projects.getIamPolicy  COMPLETED  [] 
hybrid                                container.v1.cluster    COMPLETED  []
my-hybrid-admin-reader                iam.v1.serviceAccount   COMPLETED  []
my-hybrid-admin-writer   iam.v1.serviceAccount                COMPLETED  []
my-hybrid-apigee-cluster-config  runtimeconfig.v1beta1.config COMPLETED  []
my-hybrid-apigee-cluster-vm   compute.v1.instance             COMPLETED  []
my-hybrid-apigee-cluster-waiter  runtimeconfig.v1beta1.waiter COMPLETED  []
my-hybrid-cassandra-backups      iam.v1.serviceAccount        COMPLETED  []
my-hybrid-logs-writer            iam.v1.serviceAccount        COMPLETED  []
my-hybrid-metrics-writer         iam.v1.serviceAccount        COMPLETED  []
patch-iam-policy gcp-types/cloudresourcemanager-v1:cloudresourcemanager.projects.setIamPolicy COMPLETED  []
```


## Undeploy and Clean the deployment
```sh
./clean.sh "RESOURCE_NAME"
```
e.g :
```sh
./clean.sh my-hybrid
```

## Troubleshootig



## License

Apache 2.0 - See [LICENSE](LICENSE) for more information.
