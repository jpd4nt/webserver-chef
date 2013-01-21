#
# Cookbook Name:: webserver-chef
# Recipe:: mongodb_client
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
# 

# install the xhprof pecl
php_pear "mongo" do
  action :install
end