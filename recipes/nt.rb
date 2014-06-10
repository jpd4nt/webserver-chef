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
