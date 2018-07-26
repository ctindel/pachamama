# Google Cloud Terraform Admin.

## Setup

1. [Install gcloud](https://cloud.google.com/sdk/downloads#apt-get).

    ```bash
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    sudo apt-get update && sudo apt-get install google-cloud-sdk
    ```
2. [Install Terraform](https://www.terraform.io/intro/getting-started/install.html).
    ```bash
    wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
    unzip terraform_*.zip
    sudo mv terraform /usr/bin/rm
    rm terraform_*.zip
    ```

3. [Initialize and authorize gcloud](https://cloud.google.com/sdk/docs/initializing).
    ```bash
    gcloud init
    ```
    Should launch your web browser and ask you to sign into your google account. [For service accounts, the authorization process is slightly different](https://cloud.google.com/sdk/docs/authorizing).

4. Using gcloud, [setup an admin project with a service account](https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform).

    1. Get your organization and billing id.
        ```bash
        gcloud organizations list
        gcloud beta billing accounts list
        ```
    2. Create a file with your variables and fill in. For example:
        ```bash
        cat > environment.sh << EOF
        export ENVIRONMENT=stage
        export VERSION=01
        export ORGANIZATION_ID=123412341234
        export BILLING_ID=123ABC-123ABC-123ABC
        EOF
        ```
    3. Run setup script.
        ```bash
        ./setup.sh
        ```
    4. You can now revoke gcloud access to your user account because it is no longer needed.
        ```bash
        gcloud auth list
        gcloud revoke <USER-ACCOUNT>
        ```

5. Run Terraform with the service account credentials.
    1. Create the Terraform backend file if it doesn't exist.
        ```bash
        source environment.sh
        export PROJECT=terraform-$ENVIRONMENT-$VERSION
        cat > backend.tf <<EOF
        terraform {
         backend "gcs" {
           bucket  = "$PROJECT"
           path    = "/terraform.tfstate"
           project = "$PROJECT"
         }
        }
        EOF
        ```
    2. Initialize and apply Terraform.
        ```bash
        source environment.sh
        export PROJECT=terraform-$ENVIRONMENT-$VERSION
        export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/${PROJECT}.json
        cd $ENVIRONMENT
        terraform init
        terraform apply \
          -auto-approve \
          -var org_id=$ORGANIZATION_ID \
          -var billing_account=$BILLING_ID \
          -var project=$PROJECT \
          -var environment=$ENVIRONMENT
        ```
        Google Cloud might prompt you to manually authorize certain services for the first time.
