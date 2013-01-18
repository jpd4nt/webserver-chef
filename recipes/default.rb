#
# Cookbook Name:: webserver-chef
# Recipe:: default
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when "rhel", "fedora", "centos"
  %w{ httpd-devel pcre pcre-devel php-mysqlnd php-pecl-apc php-gd php-xml php-mbstring php-mcrypt ImageMagick-devel }.each do |pkg|
    package pkg do
      action :install
    end
  end
  %w{ imagick }.each do |pkg|
    php_pear pkg do
      action :install
    end
  end
  apc_path = "/etc/php.d/apc.ini"
when "debian"
  %w{ make php5-imagick php5-mysqlnd php5-gd php5-curl libpcre3 libpcre3-dev git-core php-apc }.each do |pkg|
    package pkg do
      action :install
    end
  end
  apc_path = "/etc/php5/conf.d/apc.ini"
else
  apc_path = "/etc/php5/conf.d/apc.ini"
end

#install apc via pecl due to being able to set ini conf easily
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
# install the uploadprogress pecl
php_pear "uploadprogress" do
  action :install
end
# install the xhprof pecl
php_pear "xhprof" do
  action :install
end