# update the repos
sudo apt-get update

# Install and configure packages
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-readline mysql-server-5.6 php5-mysql git-core php5-xdebug

# Configure xdebug
cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
# Enable scream if you want to have full error reporting
xdebug.scream=0
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

# Enable PHP debuging options
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sed -i "s/disable_functions = .*/disable_functions = /" /etc/php5/cli/php.ini

# Enable mod_rewrite
sudo a2enmod rewrite
sudo service apache2 restart

# Install composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Install zsh
# this gives you the option of installing zsh frameworks
sudo apt-get install -y zsh

# Set the lang and locale
sudo apt-get install -y language-pack-en
sudo locale-gen "en_US.UTF-8"

# Remove old vhosts
sudo rm /etc/apache2/sites-enabled/*

# Create the vhosts
echo "
<VirtualHost *:80>

ServerAdmin webmaster@localhost
DocumentRoot /var/www/lengow_corporation/web
ServerName lengow.dev
ServerAlias lengow.dev

<Directory /var/www/lengow_corporation/web>
  Options Indexes FollowSymLinks MultiViews
  AllowOverride All
  Order allow,deny
  allow from all
</Directory>

ErrorLog \${APACHE_LOG_DIR}/corp_error.log
CustomLog \${APACHE_LOG_DIR}/corp_access.log combined

</VirtualHost>" > /etc/apache2/sites-available/corp.conf

sudo echo "
<VirtualHost *:80>

ServerAdmin webmaster@localhost
DocumentRoot /var/www/lengow-blog
ServerName blog.lengow.dev
ServerAlias blog.lengow.dev

<Directory /var/www/lengow-blog>
  Options Indexes FollowSymLinks MultiViews
  AllowOverride All
  Order allow,deny
  allow from all
</Directory>

ErrorLog \${APACHE_LOG_DIR}/blog_error.log
CustomLog \${APACHE_LOG_DIR}/blog_access.log combined

</VirtualHost>" > /etc/apache2/sites-available/blog.conf

sudo echo "
<VirtualHost *:80>

ServerAdmin webmaster@localhost
DocumentRoot /var/www/lengow_hub2
ServerName hub.lengow.dev
ServerAlias hub.lengow.dev

<Directory /var/www/lengow_hub2>
  Options Indexes FollowSymLinks MultiViews
  AllowOverride All
  Order allow,deny
  allow from all
</Directory>

ErrorLog \${APACHE_LOG_DIR}/hub_error.log
CustomLog \${APACHE_LOG_DIR}/hub_access.log combined

</VirtualHost>" > /etc/apache2/sites-available/hub.conf

sudo echo "
<VirtualHost *:80>

ServerAdmin webmaster@localhost
DocumentRoot /var/www/lengow_led
ServerName led.dev
ServerAlias led.dev

<Directory /var/www/lengow_led>
  Options Indexes FollowSymLinks MultiViews
  AllowOverride All
  Order allow,deny
  allow from all
</Directory>

ErrorLog \${APACHE_LOG_DIR}/led_error.log
CustomLog \${APACHE_LOG_DIR}/led_access.log combined

</VirtualHost>" > /etc/apache2/sites-available/led.conf

# Enable the sites
sudo a2ensite corp.conf
sudo a2ensite blog.conf
sudo a2ensite hub.conf
sudo a2ensite led.conf
sudo service apache2 reload
