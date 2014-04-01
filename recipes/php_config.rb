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
  when "rhel"
  else
    yum_repository 'rhscl-php54' do
      description "Copr repo for php54 owned by rhscl"
      baseurl "http://copr-be.cloud.fedoraproject.org/results/rhscl/php54/epel-6-$basearch/"
      gpgcheck false
      action :create
    end
    yum_repository 'remi-php54more' do
      description "Copr repo for php54more owned by remi"
      baseurl "http://copr-be.cloud.fedoraproject.org/results/remi/php54more/epel-6-$basearch/"
      gpgcheck false
      action :create
    end
  end
end