#!/bin/bash

uniqueId=$(gcloud beta runtime-config configs variables get-value  --config-name $1-apigee-config uniqueId)
project_id=$(gcloud config get-value project)
resource=$1
project_number=$(gcloud projects describe $project_id | grep projectNumber |  cut -d ':' -f2 | tr -d "'" | awk '{print $1}')


gcloud deployment-manager deployments delete $1

gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-$uniqueId-admin@$project_id.iam.gserviceaccount.com --role roles/apigee.admin --quiet
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-$uniqueId-synchronizer@$project_id.iam.gserviceaccount.com --role roles/apigee.synchronizerManager --quiet
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-$uniqueId-metrics@$project_id.iam.gserviceaccount.com --role roles/monitoring.metricWriter --quiet
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-$uniqueId-udca@$project_id.iam.gserviceaccount.com --role roles/apigee.analyticsAgent --quiet
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-$uniqueId-cassandra@$project_id.iam.gserviceaccount.com --role roles/storage.objectAdmin --quiet
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-$uniqueId-mart@$project_id.iam.gserviceaccount.com --role roles/storage.objectAdmin --quiet
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-$uniqueId-connect@$project_id.iam.gserviceaccount.com --role roles/apigeeconnect.Agent --quiet


gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$project_number-compute@developer.gserviceaccount.com --role roles/container.clusterAdmin --quiet
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$project_number-compute@developer.gserviceaccount.com --role roles/container.admin --quiet
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$project_number@cloudservices.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin --quiet
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$project_number@cloudservices.gserviceaccount.com --role roles/container.admin --quiet
