#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $DIR/env.sh

gsutil mb -p $GCLOUD_PROJECT gs://$PM_PROJECT-$PM_ENV
gsutil versioning set on gs://$PM_PROJECT-$PM_ENV
