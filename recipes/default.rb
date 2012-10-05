#
# Cookbook Name:: webserver-chef
# Recipe:: default
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when "rhel", "fedora"
  %w{ httpd-devel pcre pcre-devel }.each do |pkg|
    package pkg do
      action :install
    end
  end
  %w{ imagick }.each do |pkg|
    php_pear pkg do
      action :install
    end
  end
when "debian"
  %w{ make php5-imagick php5-mysqlnd libpcre3 libpcre3-dev git-core }.each do |pkg|
    package pkg do
      action :install
    end
  end
end

#install apc via pecl due to being able to set ini conf easily
php_pear "apc" do
  action          :install
  preferred_state "stable"
  directives(:shm_size => node['php']['apc']['shm_size'], :enable_cli => 0, :stat => node['php']['apc']['stat'], :enable => node['php']['apc']['enable'])
end
# install the uploadprogress pecl
php_pear "uploadprogress" do
  action :install
end
# install the xhprof pecl
php_pear "xhprof" do
  action :install
end