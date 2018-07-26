#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $DIR/environment.sh

export PROJECT=terraform-$ENVIRONMENT-$VERSION
export CREDENTIALS=~/.config/gcloud/${PROJECT}.json
export SERVICE_ACCOUNT=terraform

# Create the Terraform PROJECT Project.
gcloud projects create $PROJECT --organization $ORGANIZATION_ID --set-as-default
gcloud beta billing projects link $PROJECT --billing-account $BILLING_ID

# Create the Terraform Service Account
gcloud iam service-accounts create $SERVICE_ACCOUNT
gcloud iam service-accounts keys create $CREDENTIALS \
  --iam-account $SERVICE_ACCOUNT@$PROJECT.iam.gserviceaccount.com

# Grant the Terraform Service Account permissions to vew the PROJECT project...
gcloud projects add-iam-policy-binding $PROJECT \
  --member serviceAccount:$SERVICE_ACCOUNT@$PROJECT.iam.gserviceaccount.com \
  --role roles/viewer

# ... and manage Cloud Storage.
gcloud projects add-iam-policy-binding $PROJECT \
  --member serviceAccount:$SERVICE_ACCOUNT@$PROJECT.iam.gserviceaccount.com \
  --role roles/storage.admin

# Enable APIs
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com

# Grant the Terraform Service Account organization level permissions.
gcloud organizations add-iam-policy-binding $ORGANIZATION_ID \
  --member serviceAccount:$SERVICE_ACCOUNT@$PROJECT.iam.gserviceaccount.com \
  --role roles/resourcemanager.projectCreator

gcloud organizations add-iam-policy-binding $ORGANIZATION_ID \
  --member serviceAccount:$SERVICE_ACCOUNT@$PROJECT.iam.gserviceaccount.com \
  --role roles/billing.user

# Create bucket with versioning.
gsutil mb -p $PROJECT gs://$PROJECT
gsutil versioning set on gs://$PROJECT
