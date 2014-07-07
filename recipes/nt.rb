#
# Cookbook Name:: webserver-chef
# Recipe:: nt
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
# Config details for the NT sites, like extra modules etc
#

include_recipe "build-essential::default"

# Need this for PP
php_pear "pecl_http" do
  action :install
  version "1.7.6"
  notifies :restart, "service[apache2]", :delayed
end

case node['platform']
when "redhat","centos"
  yum_repository 'php54more' do
    description "This collection extends the php54 collection available in RHSCL or CentsOS-SCL."
    baseurl "https://www.softwarecollections.org/repos/remi/php54more/"
    gpgcheck false
    action :create
  end
  packages = %w{ memcached php54-php-pecl-memcache php54-php-mcrypt }
when "amazon"
  packages = %w{ memcached php-pecl-memcache }
end

packages.each do |pkg|
  package pkg do
    action :install
  end
end