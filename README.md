
1)	Create an IAM user with your AWS account and generate access keys for that user which can be used to setup AWS CLI.
Link: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-prereqs.html

2)	Once IAM user is created, you can download AWS CLI and install it on your local machine post which we could configure the profile for the IAM user created in step 1.
Run below commands on linux to install AWS CLI:
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

For windows:
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

3)	Run below command to check the version of AWS CLI:
aws –version

4)	 Terraform can be installed using below command on Ubuntu:
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

For windows: 
Download exe file from below link and install:
https://developer.hashicorp.com/terraform/downloads

Run terraform –help to check if terraform is installed. 

5)	Create a profile for your IAM account and use the access key credentials for setting it up using below commands:
Aws configure –profile ‘profilename’
Enter Access key name
Enter Access key 

6)	Once the profile is setup, download the files from github and run ‘terraform init’ in the folder where the files are placed.
7)	After initializing terraform, you can run ‘terraform plan’  to generate a plan for the defined modules so that you can have details on which resources are being created. After running the plan command enter the region for AWS on which you need to create the infrastructure then enter VPC name, CIDR block for the VPC and the name of the profile to create the infrastructure under that account.
8)	Once the plan is generated, run ‘terraform apply’ to create the infrastructure on AWS.
9)	You can login to AWS account to verify or run terraform state list to get the meta data of the resources created.
10)	If you want to create another infrastructure using the same config files, run terraform workspace new ‘workspacename’ and follow steps from 6-9. 
11)	To destroy the infrastructure make sure to select the workspace on which the infrastructure was created and run terraform destroy and enter the values provided while creation of the resources.




