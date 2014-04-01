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
    node['php']['packages'] = %w{ php54 php54-devel php54-cli php54-gd php54-mbstring php54-mysqlnd php54-pecl-igbinary php54-xml php54-soap php54-dba php54-mcrypt }
  when "rhel"
    node['php']['packages'] = %w{ php54-runtime php54 php54-php-devel php54-php-cli php54-php-gd php54-php-mbstring php54-php-mysqlnd php54-php-pecl-apc php54-php-xml php54-php-soap php54-php-dba }
  else
    yum_repository 'rhscl-php54' do
      description "Copr repo for php54 owned by rhscl"
      baseurl "http://copr-be.cloud.fedoraproject.org/results/rhscl/php54/epel-6-$basearch/"
      action :create
    end
    yum_repository 'remi-php54more' do
      description "Copr repo for php54more owned by remi"
      baseurl "http://copr-be.cloud.fedoraproject.org/results/remi/php54more/epel-6-$basearch/"
      action :create
    end
    node['php']['packages'] = %w{ php54 php54-devel php54-cli php54-php-pear php-pecl-igbinary }
  end
end