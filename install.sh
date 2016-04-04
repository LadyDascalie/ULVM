# update the repos
sudo apt-get update

# Install and configure packages
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get install -y make gcc build-essential php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-readline mysql-server-5.6 php5-mysql git-core php5-xdebug tcl8.5 php5-redis

# Install local instance of redis
wget http://download.redis.io/releases/redis-2.8.24.tar.gz
tar xzf redis-2.8.24.tar.gz
sudo mv redis-2.8.24 /etc/redis
cd /etc/redis
sudo make
sudo make install
cd utils
sudo ./install_server.sh

cd # Return to home dir

# Configure xdebug
cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini

# Disable scream if the error reporting gets too much
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

# Enable PHP debuging options
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sed -i "s/disable_functions = .*/disable_functions = /" /etc/php5/cli/php.ini
# Enable the php.ini mods necessary for debugging
echo '' >> /etc/php5/apache2/php.ini
echo ';;;;;;;;;;;;;;;;;;;;;;;;;;' >> /etc/php5/apache2/php.ini
echo '; Added to enable Xdebug ;' >> /etc/php5/apache2/php.ini
echo ';;;;;;;;;;;;;;;;;;;;;;;;;;' >> /etc/php5/apache2/php.ini
echo '' >> /etc/php5/apache2/php.ini
echo 'zend_extension="'$(find / -name 'xdebug.so' 2> /dev/null)'"' >> /etc/php5/apache2/php.ini
echo 'xdebug.default_enable = 1' >> /etc/php5/apache2/php.ini
echo 'xdebug.idekey = "vagrant"' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_enable = 1' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_autostart = 0' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_port = 9000' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_handler=dbgp' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_log="/var/log/xdebug/xdebug.log"' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_host=10.0.2.2 ; IDE-Environments IP, from vagrant box.' >> /etc/php5/apache2/php.ini

# Enable mod_rewrite
sudo a2enmod rewrite
sudo service apache2 restart

# Install composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Install zsh
# this gives you the option of installing zsh frameworks
sudo apt-get install -y zsh
# Doesn't matter since it's vagrant
echo "vagrant" | sudo chsh -s $(which zsh)
# Also do it for the super user
sudo su
echo "vagrant" | sudo chsh -s $(which zsh)
exit

# Set the lang and locale
# This MAY NOT WORK, if it doesnt copy and paste those commands
# in a vagrant ssh session
sudo apt-get install -y language-pack-en
sudo locale-gen "en_US.UTF-8"

# Delete enabled sites
# This allows you regenerate your vhosts with a simple vagrant provision
sudo rm /etc/apache2/sites-enabled/*

# Provision the default .vimrc
echo '
set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
filetype plugin indent on       " load file type plugins + indentation

"" Tweaks
set hidden                      " allow backgrounding buffers without writing them
set number                      " line numbers are needed
set rnu                         " if possible use relative
set scrolloff=3                 " have some context around the current line always on screen
set history=200                 " remember more Ex commands
set synmaxcol=800               " do not try to highlight long lines

" Time out on key codes but not mappings. Makes terminal Vim work sanely
set notimeout
set ttimeout
set ttimeoutlen=100

"" Whitespace
set nowrap                      " do not wrap lines
set tabstop=4 shiftwidth=4      " a tab is four spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter
set gdefault                    " replace all matches per line (instead of just first)

"" Have Vim able to edit crontab files again
set backupskip=/tmp/*,/private/tmp/*"

"" Status line
set showcmd                     " display incomplete commands

if has("statusline") && !&cp
  set laststatus=2              " always show the status bar
  set statusline=%f\ %m\ %r     " filename, modified, readonly
  set statusline+=\ %l/%L[%p%%] " current line/total lines
  set statusline+=\ %v[0x%B]    " current column [hex char]
endif
' > $HOME/.vimrc

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

# Enable additional modules if necessary
sudo a2enmod headers
sudo service apache2 reload
