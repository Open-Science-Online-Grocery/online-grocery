# Server Information

The staging server is hosted on an AWS EC2 instance with a Centos 7 AMI using
a MySQL RDS instance. There is also a S3 bucket associated on AWS. All
three things are part of the same VPC (Virtual Private Cloud) and security
group. This essentially quarantines this application (and environment) for
security reasons.

## Terraform

All of the things listed above were configured using Terraform. If you do not
have Terraform install on your system you can do so using the command
`brew install terraform`.

### Workspaces

There is a file `main.tf` that houses the majority of the configuration for
server set up. We are using terraform workspaces to manage the different
environments (for whenever we set up a production environment). This means
that both the staging and production server setup will use the same `main.tf`
file.

Here are some helpful terraform workspace commands:
* `terraform workspace list` - lists all the terraform workspaces
* `terraform workspace show` - show which workspace you are currently in
* `terraform workspace new #{workspace_name}` - create a new workspace

Check [here](https://www.terraform.io/docs/commands/workspace/list.html) for
more information if needed.

### Making changes to server structure

When you run `terraform plan` (to check what changes will ocurr without actually
making changes) or `terraform apply` (actually make changes) when in a workspace
then it will only create/modify/destroy things corresponding to that particular
workspace. When setting up the production server `main.tf` may need to be
modified a little bit to accomodate (it was written with only staging in mind).

You can write specific variables to be used in specific workspaces in
that workspace's `.tfvars` file (for example `staging.tfvars`). When you run
`terraform plan` or `terraform apply` you will need to pass a flag pointing
to the variable file to use (`terraform plan -var-file=staging.tfvars`). There
isn't a way to encrypt variable files with terraform right now so you'll need
to ask another developer who has an existing `.tfvars` file to send it to you.
This variable file contains the password for the RDS database so it can't be in
source control.

To actually make changes you will run `terraform apply -var-file=staging.tfvars`
and then type 'yes' when prompted (after making sure all the changes you want
to make are happening how you expect)

### Main.tf explained

The top of `main.tf` sets the provider to be used.

The variables listed are set so you can access them within the file, but are
actually set in a `.tfvars` file. You can give variables defaults, but in our
case this being done because we want to be explicit when setting these
variables.

The `data` area can be thought of as things that already exist but we need
to get some information from. In this case we are getting an AMI to use for
Centos 7.

The `resource` area can be thought of as things that don't exist yet and we
want to create. In this case we are creating an EC2 instance, a new s3 bucket,
and a bucket policy for that s3 bucket.

You can look [here](https://www.terraform.io/docs/providers/aws/index.html#)
for different data sources and resources to use in terraform.

The `module` area is also for creating new things that don't exist. They are
different than the resources because they don't exist within Terraform, they
have to be added/installed, similar to ansible galaxy roles. The modules we
are using is to create a vpc, a security group, and the RDS instance. You
can look up each module in the registry for inputs and outputs that each
module accepts.

Terraform modules can be found [here](https://registry.terraform.io/)

### Troubleshooting

Sometimes you might `terraform apply` and are accidentally changing something
you don't intend to change. If you don't want to run the whole terraform file
you can target a specific module/resource to run. You would do something like
this: `terraform apply -target=aws_instance.howes_grocery`. That command would
only run the configuration for the aws_instance resource.

Sometimes you might not be wanting to make changes to something, but it isn't
working right and you want to destroy it and start over (like the EC2 instance).
You can do this by "tainting" it with this command:
`terraform taint aws_instance.howes_grocery`. That command would taint the
howes_grocery instance, which means the next time `terraform apply` is run it
would destroy what currently exists and recreate it.



