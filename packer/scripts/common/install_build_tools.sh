#!/bin/bash

curl https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip -o /tmp/terraform.zip && \
    unzip -o /tmp/terraform.zip -d /usr/local/bin && \
    chmod 755 /usr/local/bin/terraform && \
    rm -f /tmp/terraform.zip \
    || exit 1

curl https://releases.hashicorp.com/packer/1.2.5/packer_1.2.5_linux_amd64.zip -o /tmp/packer.zip && \
    unzip -o /tmp/packer.zip -d /usr/local/bin && \
    chmod 755 /usr/local/bin/packer && \
    rm -f /tmp/packer.zip \
    || exit 1

curl https://releases.hashicorp.com/vault/0.10.3/vault_0.10.3_linux_amd64.zip -o /tmp/vault.zip && \
    unzip -o /tmp/vault.zip -d /usr/local/bin && \
    chmod 755 /usr/local/bin/vault && \
    rm -f /tmp/vault.zip \
    || exit 1
