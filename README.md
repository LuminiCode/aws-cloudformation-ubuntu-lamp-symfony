# AWS Cloudformation template for LAMP Stack Deployment
This is a Cloudformation template to deploy LAMP Stack to AWS! This Template is adapted for the PHP-Framework Symfony.

Tutorial in German: https://youtu.be/hcELHMOs32U

## Stack
This is LAMP Stack

- Ubuntu 20.04.3 LTS (64-bit x86)
- Apache 2.4.41
- MySQL 8.0.27
- PHP 7.4.3
- AWS CLI (current version)
- Java (openjdk version "11.0.11")

## Optionally Tools
- PhpMyAdmin 5.1.1
- Python3
- Symfony (current version)
- Jenkins (current version)

## AWS Ressourcen
- EC2-Instance ImageId: ami-0a49b025fffbbdac6 (located in Frankfurt)

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
