#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $DIR/env.sh

gsutil mb -p $GCLOUD_PROJECT gs://$GCS_BUCKET
gsutil versioning set on gs://$GCS_BUCKET
