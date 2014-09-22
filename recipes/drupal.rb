#
# Cookbook Name:: webserver-chef
# Recipe:: Drupal
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
#

drush = php_pear_channel "pear.drush.org" do
  action :discover
end

php_pear "drush" do
  action :install
  channel drush.channel_name
end

case node['platform_family']
when "rhel", "fedora", "centos"
  case node['platform']
  when "redhat"
    %w{ mysql55-mysql }.each do |pkg|
      package pkg do
        action :install
      end
    end
    %w{ drush }.each do |phpcli|
      link "/usr/bin/#{phpcli}" do
        action :create
        to "/opt/rh/#{node['php']['version']}/root/usr/bin/#{phpcli}"
        not_if {File.exists?("/usr/bin/#{phpcli}")}
      end
    end
    %w{ mysql mysqldump }.each do |phpcli|
      link "/usr/bin/#{phpcli}" do
        action :create
        to "/opt/rh/mysql55/root/usr/bin/#{phpcli}"
        not_if {File.exists?("/usr/bin/#{phpcli}")}
      end
    end
  end
end