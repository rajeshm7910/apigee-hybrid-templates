uniqueId=$(gcloud beta runtime-config configs variables get-value  --config-name $1-apigee-config uniqueId)
project_id=$(gcloud config get-value project)
resource=$1

gcloud deployment-manager deployments delete $1

gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-$uniqueId-admin@$project_id.iam.gserviceaccount.com --role roles/apigee.admin
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-$uniqueId-synchronizer@$project_id.iam.gserviceaccount.com --role roles/apigee.synchronizerManager
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-$uniqueId-metrics@$project_id.iam.gserviceaccount.com --role roles/monitoring.metricWriter
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-$uniqueId-udca@$project_id.iam.gserviceaccount.com --role roles/apigee.analyticsAgent
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-$uniqueId-cassandra@$project_id.iam.gserviceaccount.com --role roles/storage.objectAdmin
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-$uniqueId-mart@$project_id.iam.gserviceaccount.com --role roles/storage.objectAdmin
