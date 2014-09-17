#
# Cookbook Name:: webserver-chef
# Recipe:: default
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
#

include_recipe "build-essential::default"
apc_path = "#{node['php']['ext_conf_dir']}/apc.ini"
case node['platform_family']
when "rhel", "fedora", "centos"
  %w{ httpd-devel pcre pcre-devel ImageMagick-devel git libcurl-devel }.each do |pkg|
    package pkg do
      action :install
    end
  end
  %w{ php pear pecl phpize phar php-config }.each do |phpcli|
    link "/usr/bin/#{phpcli}" do
      action :create
      to "/opt/rh/php54/root/usr/bin/#{phpcli}"
      not_if {File.exists?("/usr/bin/#{phpcli}")}
    end
  end
  case node['platform']
  when "redhat"
    include_recipe "webserver-chef::_redhat"
  else
    php_pear 'apcu' do
      action :install
      preferred_state "beta"
      notifies :restart, "service[apache2]", :delayed
    end
  end
  # Fix that apache cookbook deletes ssl.conf which scalr needs
  execute 'yum reinstall mod_ssl -y' do
    not_if {File.exists?("/etc/httpd/conf.d/ssl.conf")}
  end
  php_pear 'imagick' do
    action :install
  end
when "debian"
  %w{ make php5-imagick php5-mysqlnd php5-gd php5-curl libpcre3 libpcre3-dev git-core php-apc }.each do |pkg|
    package pkg do
      action :install
    end
  end
end

#install apc via pecl due to being able to set ini conf easily
file "#{node['php']['ext_conf_dir']}/apcu.ini" do
  action :delete
end

template apc_path do
  source "apc.ini.erb"
  owner  node['apache']['user']
  group  node['apache']['group']
  mode   "0444"
  variables({
    :shm_size => node['php']['apc']['shm_size'],
    :enable_cli => 0,
    :stat => node['php']['apc']['stat'],
    :enable => node['php']['apc']['enable']
  })
  notifies :restart, "service[apache2]", :delayed
end

directory "/var/www/monitor" do
  action    :create
  mode      "0775"
  owner     node['apache']['user']
  group     node['apache']['group']
end
template "/var/www/monitor/apc.php" do
  source "apc.php.erb"
  owner  node['apache']['user']
  group  node['apache']['group']
  mode   "0444"
end
php_pear 'zendopcache' do
  action :install
  zend_extensions ['opcache.so']
  preferred_state "beta"
  notifies :restart, "service[apache2]", :delayed
end
# install the uploadprogress pecl
php_pear "uploadprogress" do
  action :install
  notifies :restart, "service[apache2]", :delayed
end
# install the xhprof pecl
php_pear "xhprof" do
  action :install
  preferred_state "beta"
  notifies :restart, "service[apache2]", :delayed
end
# Install AWS memcached library
case node['php']['version']
when "php53"
  amazon_elasticache = 'amazon-elasticache-cluster-client_php53.so'
when "php54"
  amazon_elasticache = 'amazon-elasticache-cluster-client_php54.so'
when "php55"
  amazon_elasticache = 'amazon-elasticache-cluster-client_php55.so'
end
cookbook_file amazon_elasticache do
  path "#{node['php']['ext_dir']}/amazon-elasticache-cluster-client.so"
  action :create_if_missing
end
cookbook_file "memcached.ini" do
  path "#{node['php']['ext_conf_dir']}/memcached.ini"
  action :create_if_missing
end

