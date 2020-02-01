# apigee-hyrbid-gcp

This project allows you to install apigee hybid runtime in Google Cloud Platform using GCP's deployment manager.

This template will do following
- Create kubernets clusters
- Create service accounts and assign right roles
- Install hybrid runtime
- Post install setup like adding synchronizer and mart end points.

## Prerequisite

### gcloud
- Install gcloud sdk from https://cloud.google.com/sdk/downloads
- Initialize your account
- Set gcloud to your gcp project
```
  gcloud config set project <project-id>
```

## Getting Started
- Keep Key/Certificate pair in config/ directory

ingress-server.key - The private key for ingress 
ingress-server.pem - The public key for ingress
mart-server.key - The private key for mart
mart-server.pem - The public key for mart


- Make  changes in apigee-cluster.yaml file. 

The apigee section of properties is the override.yaml. Change hostAliases and loadbalancers as you wish. In case your org name is same as projectId you can keep the same without any modification. deploy.sh will pick up the right project name and update the overridess..

- Toggle true/false in connect_agent if using apigee connect or direct mart address.

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
      gcpProjectID: {{org}}
      # Kubernetes cluster name.
      k8sClusterName: apigee-hybrid
        # Apigee org name.
      org: {{org}}
      envs:
            # Apigee environment name.
        - name: test
            # Domain name to which api traffic is sent.
          hostAlias: "{{org}}-test.hybrid-apigee.net"
            # Certificate for the domain name; this can be self signed.
          sslCertPath: ingress-server.pem
            # Private key for the domain name; this can be self signed.
          sslKeyPath: ingress-server.key
            # Service accounts for sync and UDCA.
          serviceAccountPaths:
            synchronizer: ./service-accounts/{{org}}-synchronizer-apigee.json
            udca: ./service-accounts/{{org}}-udca-apigee.json
        - name: prod
            # Domain name to which api traffic is sent.
          hostAlias: "{{org}}-prod.hybrid-apigee.net"
            # Certificate for the domain name; this can be self signed.
          sslCertPath: ingress-server.pem
            # Private key for the domain name; this can be self signed.
          sslKeyPath: ingress-server.key
            # Service accounts for sync and UDCA.
          serviceAccountPaths:
            synchronizer: ./service-accounts/{{org}}-synchronizer-apigee.json
            udca: ./service-accounts/{{org}}-udca-apigee.json
      mart:
        hostAlias: "{{org}}-mart.hybrid-apigee.net"
        serviceAccountPath: ./service-accounts/{{org}}-mart-apigee.json
        sslCertPath: mart-server.pem
        sslKeyPath:  mart-server.key
      k8sCluster:
        name: cluster_name
        region: cluster_region
      connect_agent:
        enabled: false
        serviceAccountPath: ./service-accounts/{{project_id}}-connect-apigee.json
      metrics:
        serviceAccountPath: ./service-accounts/{{org}}-metrics-apigee.json
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

- deploy.sh will add following roles to these service accounts

[PROJECT-NUMBER]@cloudservices.gserviceaccount.com

```
Kubernetes Engine Admin
Editor
Kubernetes Cluster Admin

```

- Allocate access to default compute services accouunt -

 [PROJECT-NUMBER]-compute@developer.gserviceaccount.com 

```
Kubernetes Engine Admin
Editor
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
