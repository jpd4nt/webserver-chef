#
# Cookbook Name:: webserver-chef
# Recipe:: default
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
#


case node['platform_family']
when "rhel", "fedora", "centos"
  %w{ httpd-devel pcre pcre-devel php-pecl-apc php-gd php-xml php-mbstring ImageMagick-devel git }.each do |pkg|
    package pkg do
      action :install
    end
  end
  case node['platform']
  when "amazon"
    %w{ php-mysqlnd php-mcrypt }.each do |pkg|
      package pkg do
	action :install
      end
    end
  when "rhel"
    # enable apache access to sendmail on rhel.
    selinuxCheck = `/usr/sbin/getenforce`
    selinux = `/usr/sbin/getsebool httpd_can_sendmail`
    execute "selinx_http" do
      command "/usr/sbin/setsebool -P httpd_can_sendmail 1"
      action :run
      # Don't ask me why its 4, ask ruby why its 4.
      not_if {selinux.count('on') == 4}
    end
    package 'php-mysql' do
      action :install
    end
  else
    package 'php-mysql' do
      action :install
    end
  end
  php_pear 'imagick' do
    action :install
  end
  apc_path = "/etc/php.d/apc.ini"
when "debian"
  %w{ make php5-imagick php5-mysqlnd php5-gd php5-curl libpcre3 libpcre3-dev git-core php-apc }.each do |pkg|
    package pkg do
      action :install
    end
  end
  apc_path = "/etc/php5/conf.d/apc.ini"
else
  apc_path = "/etc/php5/conf.d/apc.ini"
end

#install apc via pecl due to being able to set ini conf easily
template apc_path do
  source "apc.ini.erb"
  owner  node['apache']['user']
  group  node['apache']['group']
  mode   "0444"
  variables({
    :shm_size => node['php']['apc']['shm_size'],
    :enable_cli => 0,
    :stat => node['php']['apc']['stat'],
    :enable => node['php']['apc']['enable']
  })
  notifies :restart, "service[apache2]", :delayed
end

directory "/var/www/monitor" do
  action    :create
  mode      "0775"
  owner     node['apache']['user']
  group     node['apache']['group']
end
template "/var/www/monitor/apc.php" do
  source "apc.php.erb"
  owner  node['apache']['user']
  group  node['apache']['group']
  mode   "0444"
end
# install the uploadprogress pecl
php_pear "uploadprogress" do
  action :install
  notifies :restart, "service[apache2]", :delayed
end
# install the xhprof pecl
php_pear "xhprof" do
  action :install
  preferred_state "beta"
  notifies :restart, "service[apache2]", :delayed
end