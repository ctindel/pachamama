#!/usr/bin/env bash

#
# init.sh
#
# A script to initialize the Terraform remote state configuration settings.
# You'll want to run this every time you change AWS profiles but want to deploy
# this directory's Terraform environment.
#
# This script should be a symlink into _base_config_ but you should never run
# run this script from _base_config_.  Always run it from the real environment
# directory like dev, staging, or prod.

##### Constants

source "../../../../env.sh"

readonly FULL_PARENT_DIR="$(dirname "$PWD")"
readonly PARENT_DIR=${FULL_PARENT_DIR##*/}
readonly USERNAME_DIR=${PWD##*/}

# clear out any existing local state
[[ -d .terraform ]] && rm -rf .terraform

echo "Backend key is gs://$GCS_BUCKET/tf/$PARENT_DIR/$USERNAME_DIR/terraform.tfstate"

terraform init \
    -backend-config="bucket=$GCS_BUCKET"\
    -backend-config="project=$GCLOUD_PROJECT" \
    -backend-config="prefix=/tf/$PARENT_DIR/$USERNAME_DIR/terraform.tfstate"

terraform get -update

if [[ $? -ne 0 ]]; then
    printf '\nMake sure any variables you currently have exported match the chosen profile!\n'
    exit 1
fi
