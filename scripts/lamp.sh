# ComandLine Arguments:
# $1 (StackName) | $2 (DBUser) | $3 (DB Password) | $4 (DB Name) | $5 (DB Root Password)
# $6 (Symfony installation) | $7 (phpMyAdmin installation) | $8 (Jenkins installation)
# $9 (Existing Symfony project) | $10 (GitHubUser) | $11 (GitHubPassword)

set -e
set -x
# Set timezone
# sudo timedatectl set-timezone America/New_York

# Upgrade
sudo apt-get update
# sudo apt-get upgrade -y

# install mysql-server
sudo apt-get install -y mysql-server
sudo apt-get install mysql-client
sudo apt-get install -y libmysqlclient-dev

# install apache2
sudo apt-get install -y apache2
sudo apt-get install apache2-doc
sudo apt-get install apache2-utils

# install php
sudo apt-get install -y libapache2-mod-php7.2
sudo apt-get install php7.2
sudo apt-get install php7.2-common
sudo apt-get install php7.2-curl
sudo apt-get install -y php7.2-dev
sudo apt-get install -y php7.2-gd
sudo apt-get install php-pear
sudo apt-get install -y php-imagick
sudo apt-get install php7.2-mysql
sudo apt-get install -y php7.2-ps
sudo apt-get install php7.2-xsl
sudo apt-get install -y libmcrypt-dev
sudo apt-get install php7.2-mbstring

# install python3
sudo apt install python3

# enable mod_rewrite
sudo a2enmod rewrite

# install zip & unzip
sudo apt-get install -y zip
sudo apt-get install -y unzip

# install composer
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php
sudo php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# install git
sudo apt-get install git

# set apache2 directory for symfony
sudo curl https://raw.githubusercontent.com/LuminiCode/aws-cloudformation-ubuntu-lamp-symfony/master/settings/000-default.conf -o /etc/apache2/sites-available/000-default.conf
a1='/var/www/html'
b1='/var/www/html/'"$1"''/public
sudo sed -i 's,'"$a1"','"$b1"',' /etc/apache2/sites-available/000-default.conf

# set mysql
sudo mysql -e "CREATE DATABASE $4 /*\!40100 DEFAULT CHARACTER SET utf8 */;"
sudo mysql -e "CREATE USER $2@localhost IDENTIFIED BY '$3';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $4.* TO '$2'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$5';"

# install phpmyadmin
if [ "$7" == "true" ]
then
  # Download & unzip the last phpMyAdmin-version
  wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip
  unzip phpMyAdmin-latest-all-languages.zip
  # create folder /var/www/phpmyadmin and copy the unziped file
  sudo mkdir /var/www/phpmyadmin
  sudo cp -r phpMyAdmin-*/* /var/www/phpmyadmin/
  # change rights
  sudo chown -R ubuntu:ubuntu /var/www/phpmyadmin
  sudo chmod -R 755 /var/www/phpmyadmin
  # set configuration
  sudo curl https://raw.githubusercontent.com/LuminiCode/aws-cloudformation-ubuntu-lamp-symfony/master/settings/phpmyadmin.txt -o /etc/apache2/conf-available/phpmyadmin.conf
  # Activate Configuration
  sudo a2enconf phpmyadmin
  # solve tmp error
  sudo mkdir /var/www/phpmyadmin/tmp
  sudo mkdir /var/www/phpmyadmin/tmp/twig
  sudo chown -R ubuntu:ubuntu /var/www/phpmyadmin/tmp
  sudo chmod -R 777 /var/www/phpmyadmin/tmp
  sudo chown -R ubuntu:ubuntu /var/www/phpmyadmin/tmp/twig
  sudo chmod -R 777 /var/www/phpmyadmin/tmp/twig
  c="define('TEMP_DIR', './tmp/');"
  d="define('TEMP_DIR', '/var/www/phpmyadmin/tmp');"
  sudo sed -i "s|$c|$d|g" /var/www/phpmyadmin/libraries/vendor_config.php
  # solve configuration error (blowfish_secret)
  e="define('CONFIG_DIR', '');"
  f="define('CONFIG_DIR', '/var/www/phpmyadmin/');"
  sudo sed -i "s|$e|$f|g" /var/www/phpmyadmin/libraries/vendor_config.php
  mv /var/www/phpmyadmin/config.sample.inc.php /var/www/phpmyadmin/config.inc.php
  NEW_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  j="blowfish_secret'] = '';"
  k="blowfish_secret'] = '$NEW_PASSWORD';"
  sudo sed -i "s|$j|$k|g" /var/www/phpmyadmin/config.inc.php
fi

sudo systemctl reload apache2

# configure php.ini
sudo sed -i 's/memory_limit = .*/memory_limit = '850M'/' /etc/php/7.2/apache2/php.ini

# restart apache
sudo /etc/init.d/apache2 restart

# install symfony
if [ "$6" == "true" ]
then
  if [ "$9" == "false" ]
  then
    # install new symfonfy project
    cd /var/www/html
    export COMPOSER_HOME="$HOME/.config/composer";
    composer create-project symfony/website-skeleton $1
    composer clear

    # change database-settings in the symfony .env file
    x='DATABASE_URL=mysql://db_user:db_password@127.0.0.1:3306/db_name'
    y='DATABASE_URL=mysql://'"$2"':'"$3"'@localhost/'"$4"''
    sed -i 's,'"$x"','"$y"',' /var/www/html/$1/.env
  else
     # install an existing project from github
    # !! edit !! the following script (the following script is on github)
    mkdir /var/www/html/settings
    sudo curl https://$10:$11@raw.githubusercontent.com/LuminiCode/symfony/master/aws-install-script-sg.sh -o /var/www/html/settings/aws-install-script-sg.sh
    bash /var/www/html/settings/aws-install-script-sg.sh $1 $2 $3 $4 $10 $11
    sudo rm -r /var/www/html/settings
  fi
fi

# install jenkins
if [ "$8" == "true" ]
then
  wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
  sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
  sudo apt install openjdk-11-jdk -y
  sudo apt update
  sudo apt install jenkins -y
  sudo systemctl start jenkins
fi

# set ubuntu as the owner of document root
sudo chown ubuntu:ubuntu /var/www/html/ -R

if [ "$7" == "true" ]
then
  # delete temporary files and folders
  sudo rm -r /phpMyAdmin-4.9.1-all-languages
  sudo rm -r /phpMyAdmin-latest-all-languages.zip
fi
