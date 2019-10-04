# AWS Cloudformation template for LAMP Stack Deployment
This is a Cloudformation template to deploy LAMP Stack to AWS! This Template is adapted for the PHP-Framework Symfony.

## Stack
This is LAMP Stack

- Ubuntu 18.04.2
- Apache 2
- MySQL 5.6
- PHP 7.2.19

## AWS Ressourcen
- EC2-Instance (t2.micro located in Frankfurt)


------------

##### Notes:
You Can Create A New Symfony Project Or You Can Take An Existing Symfony-Project From Github.

For The Case You Want To Install An Existing Project You Have To Write Your Own Script!

```yaml
# install an existing project from github
# !! edit !! the following script (the following script is on github)
mkdir /var/www/html/settings
sudo curl https://${GithubUser}:${GithubPassword}@raw.githubusercontent.com/LuminiCode/symfony/master/aws-install-script-sg.sh -o /var/www/html/settings/aws-install-script-sg.sh
bash /var/www/html/settings/aws-install-script-sg.sh ${GithubUser} ${GithubPassword} ${AWS::StackName} ${DBUser} ${DBPassword} ${DBName}
```
