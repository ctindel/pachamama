#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $DIR/environment.sh
export PROJECT=terraform-$ENVIRONMENT-$VERSION
export CREDENTIALS=~/.config/gcloud/${PROJECT}.json
export SERVICE_ACCOUNT=terraform

gcloud projects delete $PROJECT

gcloud organizations remove-iam-policy-binding $ORGANIZATION_ID \
  --member serviceAccount:$SERVICE_ACCOUNT@$PROJECT.iam.gserviceaccount.com \
  --role roles/resourcemanager.projectCreator

gcloud organizations remove-iam-policy-binding $ORGANIZATION_ID \
  --member serviceAccount:$SERVICE_ACCOUNT@$PROJECT.iam.gserviceaccount.com \
  --role roles/billing.user
