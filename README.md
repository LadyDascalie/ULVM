# ULVM - Unfancy LAMP VM
## What problem does it solve ?
It provides a purposefully simple, easily configurable and lightweight VM for LAMP stack development
## What do you get ?
A very simple and documented `install.sh` shell script provisioning the VM with:
- php5
- apache2
- libapache2-mod-php5
- php5-curl
- php5-gd
- php5-mcrypt
- php5-readline
- mysql-server-5.6
- php5-mysql
- git-core
- php5-xdebug

MySQL and xdebug pre-configured to sensible defaults.

A basic dashboard listing credentials, with access to `adminer` and `phpinfo`.

## How ?
### Instructions
Clone the repo.
run `vagrant up`

While this is going, add the following entry to your `hosts` file:

```
192.168.33.10 dashboard.dev
```

Once `vagrant up` has finishes, please visit `dashboard.dev` in your browser to confirm a working installation as well as finding additional documentation.
