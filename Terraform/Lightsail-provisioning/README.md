This Terraform project was created to allow for rapid spin up of lightsail instances that are pulled from a skeleton instance that has the base configure of the needed application (Making our own version of AMI for lightsail)

The terraform scripts will perform the following actions:
- Create a cloudfront distribution that is mapped to lightsail.domain.com with specific caching behaviors for wordpress
- Generate an SSL cert for usage with cloudfront for the needed domains provided in domain.txt
- Create an SES account with IAM permissions and generate SMTP credentials to allow for usage with most wordpress plugins
- Preform Domain verification for the email domain using Easy-DKIM if the domain is hosted in route53
- Create and bind a static IPv4 address to the lightsail instance

There are some separate functions provided by createinstance.sh as it was not possible to create a lightsail instance using a snapshot from a previous instance along with alarm creation
