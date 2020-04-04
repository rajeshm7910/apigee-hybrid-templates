#!/bin/bash

#!/bin/bash

add_roles() {
	
	project_id=$(gcloud config get-value project)
	project_number=$(gcloud projects describe $project_id | grep projectNumber |  cut -d ':' -f2 | tr -d "'" | awk '{print $1}')

	gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$project_number-compute@developer.gserviceaccount.com --role roles/container.clusterAdmin --quiet
	gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$project_number-compute@developer.gserviceaccount.com --role roles/container.admin --quiet
	gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$project_number@cloudservices.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin --quiet
	gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$project_number@cloudservices.gserviceaccount.com --role roles/container.admin --quiet
}

enable_services() {
	gcloud services enable container.googleapis.com 
	gcloud services enable iam.googleapis.com
	gcloud services enable cloudresourcemanager.googleapis.com
	gcloud services enable runtimeconfig.googleapis.com
	gcloud services enable sourcerepo.googleapis.com
	gcloud services enable logging.googleapis.com
	gcloud services enable monitoring.googleapis.com
	gcloud services enable apigee.googleapis.com
	gcloud services enable apigeeconnect.googleapis.com
}

update() {
	gcloud deployment-manager deployments update $1 --config apigee-cluster.yaml
}

add_roles
enable_services
update