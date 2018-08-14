# pachamama sample packer and terraform files

Create an administrative project where you can launch a gce instance to run 
commands from.  I used ubuntu 16.04 on an f1-micro (a lot of 3rd party 
packages have not been updated to 18.04 yet.  Within that project you'll
need to create a service account that has writes to all the APIs, and also
give permissions to the gce instance to execute all the APIs as well.  You will
need to save the credentials for this service account as a JSON file 
(https://cloud.google.com/iam/docs/creating-managing-service-account-keys)

You will need to install terraform and vault onto this build server.  There are
examples of how to do that in this packer script (run sudo su - first to become
root before running these install commands):

https://github.com/ctindel/pachamama/blob/master/packer/scripts/common/install_build_tools.sh

From here you will need to edit the env.sh to include the name of your
administrative project, as well as the name of a gcs bucket where you want 
terraform to store all of its state files.  Running setup.sh will
create that bucket for you, so don't proceed until that script completes
successfully.

Next you can allocate the sandbox projects for different users.  There
are two provider examples named intern1 and intern2.  All the files in those
directories are symlinks to the underlying base_config directory, except for
terraform.tfvars which fills in the specific options for that sandbox instance.
Run "./init.sh" from the intern1 or intern2 directory and assuming that
completes successfully you'll be able to run "terraform apply" to create the 
project and assign the IAM resources for the intern.  You can run "terraform destroy"
to tear it down.  Note that GCP projects don't go away immediately as they
give you a 7-day grace period to undelete them.

The reason for the ./init.sh is to remove any cached local copies of the 
terraform state files, as it's possible that some other admin has run terraform
commands since we last refreshed those state files.

The insurance project is slightly more complicated as it allocates a lot of
other services like a docker registry, mongodb, elasticsearch, kubernetes, etc. 
Also you can have different environments of insurance projects (insurance-dev, 
insurance-staging, insurance-prod).  Each of which have their own instance
of the registry, mongodb, elasticsearch etc modules.

There is a bit of chicken and egg problem as these resources are dependent on an 
ubuntu image being built by packer inside of the project that is allocated.  So
when you want to deploy the insurance-prod project for example, you will go 
into the insurance/prod provider directory, run "bash ./init.sh", and then 
"terraform apply".  This apply will create the insurance-prod project, but
will then fail on a later resource because the required ubuntu image doesn't
yet exist in the project.  

Now you will go to the packer directory.  Edit the pachamama_base.conf and
change the account_file setting to the JSON file for your admin service
account key json file that you exported earlier.  Also you will need to make
sure that the environment variable like PM_ENV=prod is exported into
your shell environment.  Then you can run "packer build pachamama_base.conf"
and if it succeeds you will see a new gce image listed.  

Now you can go back and re-run the terraform apply which would succeed
now that the image exists.  If you rebuild the packer image, the image ID that
is referenced by the resources like the compute group (the "ASG") will no 
longer be valid so you'll need to re-run the terraform apply to update the 
group's image ID.

I had originally defined both an external and internal k8s cluster but
decided against it after talking to some people.  Internal and external
services can both co-exists on the same k8s and you have to explicitly tell
k8s that a service can be accessed externally.  Feel free to re-use the
"internal" config which is commented out for a gpu k8s cluster.

There is a bastion host which is publicly accessible via SSH; none of the other
allocated instances are accessible from the internet.  You will need to ssh
to the bastion host first, and then bounce to the other instances.  Inside
the internal network all the instances are available by name like 
"elk1.internal" or just "elk1" or "registry.internal" / "registry". You can
also assign a static IP to the bastion host and associate that IP with your 
own DNS domain if you have one; as it stands now the bastion host IP address
will change every time it reboots.
