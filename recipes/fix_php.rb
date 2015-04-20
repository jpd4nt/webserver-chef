#
# Cookbook Name:: webserver-chef
# Recipe:: fix_php
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when "rhel", "fedora", "centos"
  cookbook_file "#{node['php']['version']}-php.conf" do
    path "/etc/httpd/conf-enabled/php.conf"
    action :create_if_missing
    notifies :restart, "service[apache2]", :delayed
  end
end