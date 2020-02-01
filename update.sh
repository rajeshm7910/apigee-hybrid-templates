#!/bin/bash

project_id=$(gcloud config get-value project)
project_number=$(gcloud projects describe $project_id | grep projectNumber |  cut -d ':' -f2 | tr -d "'" | awk '{print $1}')

gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$project_number-compute@developer.gserviceaccount.com --role roles/container.clusterAdmin --quiet
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$project_number-compute@developer.gserviceaccount.com --role roles/container.admin --quiet
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$project_number@cloudservices.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin --quiet
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$project_number@cloudservices.gserviceaccount.com --role roles/container.admin --quiet

sed  "s/{{org}}/$project_id/g" apigee-cluster.yaml > apigee-cluster-main.yaml
uniqueId=$(gcloud beta runtime-config configs variables get-value  --config-name $1-apigee-config uniqueId)
sed -i.bak "s/{{uniqueId}}/$uniqueId/g" apigee-cluster-main.yaml
gcloud deployment-manager deployments update $1 --config apigee-cluster-main.yaml
rm -fr apigee-cluster-main.yaml*
