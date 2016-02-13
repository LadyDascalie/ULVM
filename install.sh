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
# This MAY NOT WORK, if it doesnt copy and paste those commands
# in a vagrant ssh session
sudo apt-get install -y language-pack-en
sudo locale-gen "en_US.UTF-8"

# Delete enabled sites
# This allows you regenerate your vhosts with a simple vagrant provision
sudo rm /etc/apache2/sites-enabled/*

# Provision vhosts
# You can add more by copy pasting and editing to your needs
echo "
<VirtualHost *:80>

ServerAdmin webmaster@localhost
DocumentRoot /var/www/dashboard
ServerName dashboard.dev
ServerAlias dashboard.dev

<Directory /var/www/dashboard/web>
  Options Indexes FollowSymLinks MultiViews
  AllowOverride All
  Order allow,deny
  allow from all
</Directory>

ErrorLog \${APACHE_LOG_DIR}/dashboard_error.log
CustomLog \${APACHE_LOG_DIR}/dashboard_access.log combined

</VirtualHost>" > /etc/apache2/sites-available/dashboard.conf

# Enable the sites
# Add your own entries here for each vhosts you add in the install script
sudo a2ensite dashboard.conf
sudo service apache2 reload
