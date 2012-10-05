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
  php_pear "apc" do
    action :install
    directives(:shm_size => "128M", :enable_cli => 0)
  end
  %w{ imagick }.each do |pkg|
    php_pear pkg do
      action :install
    end
  end
when "debian"
  %w{ make php5-imagick php-apc php5-mysql php5-mysqlnd  }.each do |pkg|
    package pkg do
      action :install
    end
  end
end

# install the uploadprogress pecl
php_pear "uploadprogress" do
  action :install
end
# install the xhprof pecl
php_pear "xhprof" do
  action :install
end