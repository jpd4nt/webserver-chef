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

default['php']['mongo']['version'] = '1.4.0'

case node['platform_family']
when "rhel", "fedora", "centos"
  case node['platform']
  when "amazon"
    default['php']['packages'] = %w{ php54 php54-devel php54-cli php54-gd php54-mbstring php54-mysqlnd php54-pecl-igbinary php54-xml php54-soap php54-dba php54-mcrypt }
    default['apache']['package'] = 'httpd24'
    default['apache']['default_modules'] = %w[
      status alias auth_basic authn_file authz_core authz_groupfile authz_host authz_user autoindex
      dir env mime negotiation setenvif
    ]
    default['mysql']['server']['packages'] = %w[mysql-server]
  when "rhel"
    default['php']['packages'] = %w{ php54 php54-php php54-runtime php54-php-devel php54-php-cli php54-php-gd php54-php-mbstring php54-php-mysqlnd php54-php-pecl-apc php54-php-xml php54-php-soap php54-php-dba }
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
