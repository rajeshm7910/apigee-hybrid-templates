#!/bin/bash

#!/bin/bash

update() {
	gcloud deployment-manager deployments update $1 --config apigee-cluster.yaml
}

update "$@"