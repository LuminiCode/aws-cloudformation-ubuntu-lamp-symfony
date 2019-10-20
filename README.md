# AWS Cloudformation template for LAMP Stack Deployment
This is a Cloudformation template to deploy LAMP Stack to AWS! This Template is adapted for the PHP-Framework Symfony.

## Stack
This is LAMP Stack

- Ubuntu 18.04.2
- Apache 2
- MySQL 5.7
- PHP 7.2.19

## Optionally Tools
- PhpMyAdmin
- Python3
- Symfony
- Jenkins

## AWS Ressourcen
- EC2-Instance (t2.micro located in Frankfurt)

## Another Ressources
- GitHub

------------

## Description:
#### Symfony:
- Path: *domain.com*

**Notes:**
You can create a new symfony project or you can take an existing Symfony-Project from Github.
For the case you want to install an existing project you have to write your own script!

```yaml
# install an existing project from github
# !! edit !! the following script (the following script is on github)
mkdir /var/www/html/settings
sudo curl https://${GithubUser}:${GithubPassword}@raw.githubusercontent.com/LuminiCode/symfony/master/aws-install-script-sg.sh -o /var/www/html/settings/aws-install-script-sg.sh
bash /var/www/html/settings/aws-install-script-sg.sh ${GithubUser} ${GithubPassword} ${AWS::StackName} ${DBUser} ${DBPassword} ${DBName}
```
#### phpMyAdmin: 
- Path: *domain.com/phpmyadmin*

#### Jenkins: 
- Path: *domain.com:8080*
- Unlock: In the terminal window, use the cat command to display the password
```shell
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
