#
# Cookbook Name:: webserver-chef
# Recipe:: php_config
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when "rhel", "fedora", "centos"
  case node['platform']
  when "amazon"
  when "redhat"
    %w{ php php-common }.each do |pkg|
      package pkg do
        action :remove
      end
    end
  else
    if node["platform_version"].to_f <= 6.0
      %w{ php php-common }.each do |pkg|
        package pkg do
          action :remove
        end
      end
      yum_repository "rhscl-#{node['php']['version']}" do
        description "Copr repo for #{node['php']['version']} owned by rhscl"
        baseurl "http://copr-be.cloud.fedoraproject.org/results/rhscl/#{node['php']['version']}/epel-6-$basearch/"
        gpgcheck false
        action :create
      end
      yum_repository "remi-#{node['php']['version']}more" do
        description "Copr repo for #{node['php']['version']}more owned by remi"
        baseurl "http://copr-be.cloud.fedoraproject.org/results/remi/#{node['php']['version']}more/epel-6-$basearch/"
        gpgcheck false
        action :create
      end
    else if node["platform_version"].to_f <= 7.0
      yum_repository "rhscl-#{node['php']['version']}" do
        description "Copr repo for #{node['php']['version']} owned by rhscl"
        baseurl "http://copr-be.cloud.fedoraproject.org/results/rhscl/#{node['php']['version']}/epel-7-$basearch/"
        gpgcheck false
        action :create
      end
      yum_repository "remi-#{node['php']['version']}more" do
        description "Copr repo for #{node['php']['version']}more owned by remi"
        baseurl "http://copr-be.cloud.fedoraproject.org/results/remi/#{node['php']['version']}more/epel-7-$basearch/"
        gpgcheck false
        action :create
      end
    end
    
  end
end
