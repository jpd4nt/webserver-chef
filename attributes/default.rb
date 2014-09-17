#
# Cookbook Name:: webserver-chef
# Recipe:: default
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
#

default['php']['apc']['enable']   = '1'
default['php']['apc']['shm_size'] = '512M'
default['php']['apc']['stat']     = '1'
default['php']['apc']['username'] = 'apc'
default['php']['apc']['password'] = 'password1'
default['php']['geos']['version'] = 'geos-3.4.2'
default['php']['version'] = 'php54' 

default['php']['mongo']['version'] = '1.5.5'

case node['platform_family']
when "rhel", "fedora", "centos"
  case node['platform']
  when "amazon"
    default['php']['php54'] = %w{ php54 php54-devel php54-cli php54-gd php54-mbstring php54-mysqlnd php54-pecl-igbinary php54-xml php54-soap php54-dba php54-mcrypt }
    default['php']['php55'] = %w{ php55 php55-devel php55-cli php55-gd php55-mbstring php55-mysqlnd php55-pecl-igbinary php55-xml php55-soap php55-dba php55-mcrypt }
    default['php']['packages'] = node['php'][node['php']['version']]
    default['apache']['package'] = 'httpd24'
    default['apache']['default_modules'] = %w[
      status alias auth_basic authn_file authz_core authz_groupfile authz_host authz_user autoindex
      dir env mime negotiation setenvif
    ]
    default['mysql']['server']['packages'] = %w[mysql-server]
  when "redhat"
    default['php']['php54'] = %w{ php54 php54-php php54-runtime php54-php-devel php54-php-cli php54-php-gd php54-php-mbstring php54-php-mysqlnd php54-php-pecl-apc php54-php-xml php54-php-soap php54-php-dba }
    default['php']['php55'] = %w{ php55 php55-php php55-runtime php55-php-devel php55-php-cli php55-php-gd php55-php-mbstring php55-php-mysqlnd php55-php-xml php55-php-soap php55-php-dba php55-php-pecl-jsonc php55-php-pecl-memcache }
    default['php']['packages'] = node['php'][node['php']['version']]
    default['php']['pear']         = '/opt/rh/php54/root/usr/bin/pear'
    default['php']['pecl']         = '/opt/rh/php54/root/usr/bin/pecl'
    default['php']['bin']          = '/opt/rh/php54/root/usr/bin/php'
    default['php']['ext_conf_dir'] = '/opt/rh/php54/root/etc/php.d'
    default['php']['ext_dir']      = '/opt/rh/php54/root/usr/lib64/php/modules'
  else
    default['php']['packages'] = %w{ php54 php54-php php54-runtime php54-php-devel php54-php-cli php54-php-gd php54-php-mbstring php54-php-mysqlnd php54-php-xml php54-php-soap php54-php-dba php54-php-pecl-igbinary }
    default['php']['pear']         = '/opt/rh/php54/root/usr/bin/pear'
    default['php']['pecl']         = '/opt/rh/php54/root/usr/bin/pecl'
    default['php']['bin']          = '/opt/rh/php54/root/usr/bin/php'
    default['php']['ext_conf_dir'] = '/opt/rh/php54/root/etc/php.d'
    default['php']['ext_dir']      = '/opt/rh/php54/root/usr/lib64/php/modules'
  end
end
