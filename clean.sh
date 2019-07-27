gcloud deployment-manager deployments delete $1

project_id=$(gcloud config get-value project)
resource=$1

gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-admin-writer@$project_id.iam.gserviceaccount.com --role roles/apigee.admin
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-admin-reader@$project_id.iam.gserviceaccount.com --role roles/apigee.readOnlyAdmin
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-logs-writer@$project_id.iam.gserviceaccount.com --role roles/logging.logWriter
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-metrics-writer@$project_id.iam.gserviceaccount.com --role roles/monitoring.metricWriter
gcloud projects remove-iam-policy-binding $project_id --member serviceAccount:$resource-cassandra-backups@$project_id.iam.gserviceaccount.com --role roles/storage.objectAdmin
