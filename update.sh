project=$(gcloud config get-value project)
projectNumber=$(gcloud projects describe $project | grep projectNumber |  cut -d ':' -f2 | tr -d "'" | awk '{print $1}')

gcloud projects add-iam-policy-binding $project --member serviceAccount:$projectNumber-compute@developer.gserviceaccount.com --role roles/container.clusterAdmin
gcloud projects add-iam-policy-binding $project --member serviceAccount:$projectNumber@cloudservices.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin
gcloud projects add-iam-policy-binding $project --member serviceAccount:$projectNumber@cloudservices.gserviceaccount.com --role roles/container.admin

sed  "s/{{org}}/$project/g" apigee-cluster.yaml > apigee-cluster-main.yaml
uniqueId=$(echo $((RANDOM%10000)))
sed -i.bak "s/{{uniqueId}}/$uniqueId/g" apigee-cluster-main.yaml

gcloud deployment-manager deployments update $1 --config apigee-cluster-main.yaml
rm -fr apigee-cluster-main.yaml*
